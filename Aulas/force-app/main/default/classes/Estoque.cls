public class Estoque {
    public String nome;
    public String cidade;
    Map<Produto, Integer> mapProdutosQuantidade;
    
    public Estoque(String nome, String cidade) {
        this.nome = nome;
        this.cidade = cidade;
        mapProdutosQuantidade = new Map<Produto, Integer>();
    }


    //incrementar a quantidade de todos os produtos de uma mesma categoria
    public void incrementarQtdProdutosCategoria(String categoria, Integer qtd) {
        /**
         * iterar no mapa
         * achar categoria
         * incrementar qtd
         * map.keySet() => retorna um set com todas as chaves
         * map.values() => retorna uma lista com todos os valores
         * map.get(key) => retorna o valor da key
         * map.put(key, value) => adiciona/substitui uma key e um valor ao mapa
         */

         for (Produto p : mapProdutosQuantidade.keySet()) {
            if (p.categoria == categoria) {
                addProduto(p, qtd);
            }
         }
    }

    public void addProduto(Produto p, Integer qtd) {
        if (!mapProdutosQuantidade.containsKey(p)) {
            mapProdutosQuantidade.put(p, 0);
        }

        mapProdutosQuantidade.put(p, (mapProdutosQuantidade.get(p) + qtd));
    }

    public List<Produto> getProdutosEstoqueMenor(Integer valor) {
        List<Produto> produtos = new List<Produto>();

        for (Produto produto : mapProdutosQuantidade.keySet()) {
            if (mapProdutosQuantidade.get(produto) < valor) {
                produtos.add(produto);
            }
        }

        return produtos;
    }
}