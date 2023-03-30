public with sharing class CatalogoPreco {
    public String nome;
    public Map<Produto, Decimal> mapProdutosPrecos;

    public CatalogoPreco(String nome) {
        this.nome = nome;
        mapProdutosPrecos = new Map<Produto, Decimal>();
    }
}