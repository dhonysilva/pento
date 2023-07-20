defmodule PentoWeb.ProductLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        multipart
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:unit_price]} type="number" label="Unit price" step="any" />
        <.input field={@form[:sku]} type="number" label="Sku" />

        <div id="images">
          <div
            class="p-4 border-2 border-dashed border-slate-300 rounded-md text-center text-slate-600"
            phx-drop-target={@uploads.image.ref}
          >
            <div class="flex flex-row items-center justify-center">
              <.live_file_input upload={@uploads.image} />
              <span class="font-semibold text-slate-500">or drag and drop here</span>
            </div>
          </div>
        </div>

        <div class="mt-4 flex flex-row flex-wrap justify-start content-start items-start gap-2">
          <div
            :for={entry <- @uploads.image.entries}
            class="flex flex-col items-center justify-start space-y-1"
          >
            <div class="w-32 h-32 overflow-clip">
              <.live_img_preview entry={entry} />
            </div>

            <div class="w-full">
              <div class="mb-2 text-xs font-semibold inline-block text-slate-600">
                <%= entry.progress %>%
              </div>
              <div class="flex h-2 overflow-hidden text-base bg-slate-200 rounded-lg mb-2">
                <span style={"width: #{entry.progress}%"} class="shadow-md bg-slate-500"></span>
              </div>
              <.error :for={err <- upload_errors(@uploads.image, entry)}>
                <%= Phoenix.Naming.humanize(err) %>
              </.error>
            </div>
            <a phx-click="cancel" phx-target={@myself} phx-value-ref={entry.ref}>
              <.icon name="hero-trash" />
            </a>
          </div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> allow_upload(
       :image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       max_file_size: 9_000_000,
       auto_upload: true
     )}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def params_with_image(socket, params) do
    path =
      socket
      |> consume_uploaded_entries(:image, &upload_static_file/2)
      |> List.first()

    Map.put(params, "image_upload", path)
  end

  defp upload_static_file(%{path: path}, _entry) do
    filename = Path.basename(path)
    dest = Path.join("priv/static/images", filename)
    File.cp!(path, dest)

    {:ok, ~p"/images/#{filename}"}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    product_params = params_with_image(socket, product_params)

    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    product_params = params_with_image(socket, product_params)

    case Catalog.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
