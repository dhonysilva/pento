# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Pento.Catalog

products = [
  %{
    name: "Chess",
    description: "The classic strategy game",
    sku: 5_678_910,
    unit_price: 10.00
  },
  %{
    name: "Tic-Tac-Toe",
    description: "The game of Xs and 0s",
    sku: 11_121_314,
    unit_price: 3.00
  },
  %{
    name: "Table Tennis",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_324,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 01",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_124,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 02",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_224,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 03",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_324,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 04",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_424,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 05",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_524,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 06",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_624,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 07",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_724,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 08",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_724,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 09",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_326,
    unit_price: 12.00
  },
  %{
    name: "Table Tennis 10",
    description: "Bat the ball back and forth. Don't miss",
    sku: 15_222_325,
    unit_price: 11.00
  }
]

Enum.each(products, fn product ->
  Catalog.create_product(product)
end)
