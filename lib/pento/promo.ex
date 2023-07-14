defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  # Ainda não entendi o motivo dessa função
  # Context function creates a new changeset using the recipient
  # from state and the params from the form change event
  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(_recipient, _attrs) do
    # Send email to promo recipient
    {:ok, %Recipient{}}
  end
end
