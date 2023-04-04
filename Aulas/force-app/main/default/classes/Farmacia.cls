public with sharing class Farmacia {
    public Estoque__c est;
    public CatalogoPreco__c cp;
    public String nome;
    public String cidade;

    public Farmacia(String nome, String cidade, Estoque est, CatalogoPreco cp) {
        this.nome = nome;
        this.cidade = cidade;
        this.est = est;
        this.cp = cp;
    }

    public Pedido gerarPedido(List<Produto> produtos) {
        Pedido__c p = new Pedido();
        for (Produto prod : produtos) {
            if (est.temEmEstoque(prod)) {
                addProduto(p, prod, 1);
            } else {
                System.debug('sdfs');
            }
        }
        //verificar estoque, preço do catálogo tem que bater
        //verificar se tem produto em estoque
        //se tem, decrementar 1 do estoque
        //se não tem, System.debug('Produto em falta: ' + produto.Name);
        //gerar um pedido, com valor total
        insert p;
    }

    private void addProduto(Pedido ped, Produto prod, Integer qtd) {
        ped.addProduto(produto, qtd);
        est.decrementar(produto, qtd);
    }

    recebe id de pedido OU lista de id de pedidos
validar se tem TODOS os produtos em estoque (qtd pedida <= qtd em estoque)
se tiver:
   atualizar quantidade em estoque
   atualizar status do pedido para Completo
se não tiver ALGUM:
   atualiza quantidade em estoque de todos que tem em estoque
   atualiza status do pedido para Parcial
   atualiza campo Pendencia no produto do pedido que não tem estoque para TRUE
}