public class Pedido {
    public String id;
    public String cliente;
    public Map<String, Integer> produtos;
    public Decimal valorTotal;

    public Pedido(String cliente) {
        this.id = Utils.generateRandomString(10);
        this.cliente = cliente;
        this.produtos = new Map<String, Integer>();
    }

    public void addProduto(String produto, Integer qtd) {
        if (!produtos.containsKey(produto)) {
            produtos.put(produto, 0);
        }

        produtos.put(produto, produtos.get(produto) + qtd);
    }

    public Integer getQuantidadeProdutos() {
        Integer quantidade = 0;

        for (String key : produtos.keySet()) {
            quantidade += produtos.get(key);
        }

        return quantidade;
    }
}