# Shopping

## Smart contract and a series of debotes for him on the topic "shopping list"

The application consists of the following contracts:

IShopping -  contains structures, interfaces and an abstract contract included in the project.

ShoppingList - a list of possible tasks.

ShoppingDebot has two heirs: ShoppingListMakingDebot and ShoppingInStoreDebot. They are already deployed on the blockchain.

### net.ton.dev

ShoppingListMakingDebot - the debot of creating a shopping list.

Address: 0:A2eedff2d6ca56a05b5a023caad3232b04fe8f1657d2cb243bfa350a942a73cf1

Link to the deployed debot:

https://uri.ton.surf/debot?address=0%3A2eedff2d6ca56a05b5a023caad3232b04fe8f1657d2cb243bfa350a942a73cf1&net=devnet


ShoppingInStoreDebot - the debot of shopping in the store according to the list.

Address: 0:2413c515358bda5c23763aa86cc4c6b98d2daa217f4ace0c8ad160e17ef4812f

Link to the deployed debot:

https://uri.ton.surf/debot?address=0%3A2413c515358bda5c23763aa86cc4c6b98d2daa217f4ace0c8ad160e17ef4812f&net=devnet


## How to deploy a project in net.tun.dev

First let's create a file ShoppingList.decode.json, we will need it for the deployment of debotes ShoppingListMakingDebot and ShoppingInStoreDebot. To do this, run the following command:

 ```
$ ./create_decode.sh ShoppingList
 ```

Deployment of the debot ShoppingListMakingDebot:

 ```
$ ./deploy_debot.sh ShoppingListMakingDebot.tvc https://net.ton.dev
 ```

Deployment of the debot ShoppingInStoreDebot:

 ```
$ ./deploy_debot.sh ShoppingInStoreDebot.tvc https://net.ton.dev
```



**************************************************



## Смарт-контракт и серия деботов для него по теме "список покупок"

Приложение состоит из следующих контрактов:

IShopping - содержит структуры, интерфейсы и абстрактный контракт, включаемые в проект.

ShoppingList - список возможных задач.

ShoppingDebot имеет два наследника: ShoppingListMakingDebot и ShoppingInStoreDebot. Они уже развернуты на блокчейне.

### net.ton.dev

ShoppingListMakingDebot - дебот создания списка покупок.

Адрес: 0:A2eedff2d6ca56a05b5a023caad3232b04fe8f1657d2cb243bfa350a942a73cf1

Ссылка на развернутый дебот:

https://uri.ton.surf/debot?address=0%3A2eedff2d6ca56a05b5a023caad3232b04fe8f1657d2cb243bfa350a942a73cf1&net=devnet


ShoppingInStoreDebot - дебот покупок в магазине по списку.

Адрес: 0:2413c515358bda5c23763aa86cc4c6b98d2daa217f4ace0c8ad160e17ef4812f

Ссылка на развернутый дебот:

https://uri.ton.surf/debot?address=0%3A2413c515358bda5c23763aa86cc4c6b98d2daa217f4ace0c8ad160e17ef4812f&net=devnet

 
## Как развернуть проект в net.ton.dev

Сначала создадим файл ShoppingList.decode.json, он нам понадобится для деплоинга деботов ShoppingListMakingDebot и ShoppingInStoreDebot. Для этого запустим следующую команду:

 ```
$ ./create_decode.sh ShoppingList
 ```

Деплоинг дебота ShoppingListMakingDebot:

 ```
$ ./deploy_debot.sh ShoppingListMakingDebot.tvc https://net.ton.dev
 ```

Деплоинг дебота ShoppingInStoreDebot:

 ```
$ ./deploy_debot.sh ShoppingInStoreDebot.tvc https://net.ton.dev
 ```