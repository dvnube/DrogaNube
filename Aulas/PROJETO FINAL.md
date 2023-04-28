PROJETO FINAL
- Data máxima de entrega: 25/06
- Nível de exigência: máxima possível, pois definirá se ganhará o certificado ou não
- Número máximo de tentativas: 2
    - a primeira apresentação não é "eliminatória"
    - darei o feedback e solicitarei as mudanças/melhorias/etc
- Aulas para tirada de dúvidas, troubleshooting, etc: terça e quinta de 19 às 20
- Apresentações: 
    - câmera ligada, todas/os
    - presença obrigatória em todas, se deseja o certificado.
    - se apresentou e passou, tá liberada/o de assistir as outras - apresentações
    - enquanto não passar, presença obrigatória.
    - feedback realtime, ao vivo
    - marcar com antecedência de, pelo menos, 2 semanas, para todas/os se programarem.
    - horários disponíveis: terça e quinta de 19 às 20




---- REQUISITOS OBRIGATÓRIOS ----

- Trigger before insert --- FEITO (produto estoque)
    - Objeto: qualquer
    - Critérios de aceitação: 
        - Validação de campo --- (valida quantidade- FEITO)
        - Setar um valor padrão em determinado campo --- (nome do produto - FEITO)
            - Exemplo (não pode usar esse):
                - Ao inserir um pedido, setar o valor Status = Draft.

- Trigger before update --- FEITO (produto estoque)
    - Objeto: qualquer
    - Critério de aceitação
        - Validação de campo

- Trigger after insert --- FEITO (pedido)
    - Objeto: qualquer
    - Atualização de campo em registro relacionado

- Trigger after update --- FEITO (account)
    - Objeto: qualquer
    - Disparar e-mail

- Trigger before delete
    - Objeto: qualquer
    - Validação: não permitir a exclusão SE "alguma coisa" (criatividade, pede ajuda pro ChatGPT no brainstorming...)





Aqui vcs vão utilizar um macete merda, mas que vai facilitar, e muito, a vida de vcs...
Pelo menos pra resolver esse problema...
1) Criar campo do tipo Checkbox, chamado RecalcularValorTotal__c no objeto Pedido__c
2) Criar campo moeda/numérico, chamado ValorTotal__c no objeto Pedido__c
3) Criar campo moeda/numérico, chamado Valor__c no objeto ProdutoPedido__c

- Trigger after insert
    - Objeto: Produto do Pedido
    - Atualize o campo "RecalcularValorTotal__c" no objeto "Pedido__c" para TRUE
- Trigger after update
    - Objeto: Produto do Pedido
    - SE "Valor__c" foi alterado ENTÃO
        - Atualize o campo "RecalcularValorTotal__c" no objeto "Pedido__c" para TRUE
- Trigger after delete
    - Objeto: Produto do Pedido
    - Atualize o campo "RecalcularValorTotal__c" no objeto "Pedido__c" para TRUE
- Trigger after undelete
    - Objeto: Produto do Pedido
    - Atualize o campo "RecalcularValorTotal__c" no objeto "Pedido__c" para TRUE

- Trigger before update
    - Objeto: Pedido
    - SE ("RecalcularValorTotal__c" foi alterado para true) ENTÃO
        - Atualize o campo ValorTotal__c adequadamente (dica: usar SUM - AggregateResult - google it)
        - Atualize o campo "RecalcularValorTotal__c" para FALSE