/**
 * recebe id de pedido OU lista de id de pedidos
validar se tem TODOS os produtos em estoque (qtd pedida <= qtd em estoque)
se tiver:
   atualizar quantidade em estoque
   atualizar status do pedido para Completo
se não tiver ALGUM:
   atualiza quantidade em estoque de todos que tem em estoque
   atualiza status do pedido para Parcial
   atualiza campo Pendencia no produto do pedido que não tem estoque para TRUE
 */
public class Pedidos {
    public static void valida(Id pedidoId) {
        //BUSCANDO INFORMAÇÕES - START
        //SOQL - pedido
        Pedido__c pedido = [
            SELECT Id, Farmacia__r.Estoque__c, (SELECT Id, Quantidade__c, Pendencia__c, Produto__c FROM Produtos__r)
            FROM Pedido__c
            WHERE Id = :pedidoId
        ];
        //produtos do pedido
        List<ProdutoPedido__c> produtosPedido = pedido.Produtos__r;

        //SOQL - estoque
        Estoque__c estoque = [
            SELECT Id, (SELECT Id, Quantidade__c, Produto__c FROM Produtos__r)
            FROM Estoque__c
            WHERE Id = :pedido.Farmacia__r.Estoque__c
        ];
        //produtos do estoque
        List<ProdutoEstoque__c> produtosEstoque = estoque.Produtos__r;
        //BUSCANDO INFORMAÇÕES - END

        //ATUALIZAÇÃO DE ESTOQUE E PENDENCIA
         for (ProdutoPedido__c pp : produtosPedido) { //para cada produto do pedido
            for (ProdutoEstoque__c pe : produtosEstoque) { //para cada produto do estoque
                if (pp.Produto__c == pe.Produto__c) { //procura o produto relacionado no estoque
                    if (pe.Quantidade__c == 0) { //encontrou, verifica se a quantidade é 0
                        pp.Pendencia__c = true; //se sim, pendencia = true
                    } else { //se a quantidade não é 0, ou seja, tem em estoque
                        if (pp.Quantidade__c <= pe.Quantidade__c) { //verifica se a quantidade pedida tem em estoque
                            pe.Quantidade__c = pe.Quantidade__c - pp.Quantidade__c; //atualiza o estoque
                        } else { //não tem a quantidade suficiente em estoque
                            pp.Pendencia__c = true; //NAÕ VENDE O PRODUTO, MARCA COM PENDENCIA, GERENTE SE VIRA
                        }
                    }
                    break; //já encontrou o produto no estoque, já realizou a lógica toda e não preciso continuar executando
                } else { //ainda não achei o produto do pedido no estoque
                    //esse ELSE é inútil, pode ser removido.
                }
            }
         }

         update produtosPedido; //DML - atualiza os produtos do pedido (campo Pendencia__c)
         update produtosEstoque; //DML - atualiza as quantidades em estoque

         //SOQL - busca o pedido e os produtos relacionados onde Pendencia__c = true
         pedido = [
            SELECT 
                Id, 
                Farmacia__r.Estoque__c, 
                Status__c,
                (SELECT Id, Quantidade__c, Pendencia__c FROM Produtos__r WHERE Pendencia__c = true) //produtos relacionados
            FROM Pedido__c
            WHERE Id = :pedidoId
        ];

        if (pedido.Produtos__r.isEmpty()) { //se nenhum produto do pedido possui pendência
            pedido.Status__c = 'Completo'; //atualiza status para completo
        } else { //se algum produto do pedido possui pendência
            pedido.Status__c = 'Parcial'; //atualiza status para parcial
        }

        update pedido; //DML para atualizar o pedido (campo status);

    }
}
