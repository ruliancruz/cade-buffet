<div align="center">
  <h1>Cadê Buffet</h1>
  <div>
    <img src="http://img.shields.io/static/v1?label=Ruby&message=3.3.0&color=red&style=for-the-badge&logo=ruby"/>
    <img src="http://img.shields.io/static/v1?label=Ruby%20On%20Rails%20&message=7.1.3.2&color=red&style=for-the-badge&logo=ruby"/>
    <img src="https://img.shields.io/static/v1?label=SQLite3&message=1.4&color=blue&style=for-the-badge&logo=sqlite"/>
    <img src="http://img.shields.io/static/v1?label=Tests&message=266&color=GREEN&style=for-the-badge"/>
    <img src="http://img.shields.io/static/v1?label=Code%20to%20Test%20Ratio&message=4.2&color=GREEN&style=for-the-badge"/>
    <img src="http://img.shields.io/static/v1?label=Status&message=Under%20Development&color=RED&style=for-the-badge"/>
  </div><br>

  Buffet finder platform to intermediate orders between clients and buffets. It also has an API.
</div>


## Table of Contents

:small_blue_diamond: [What The Application Can Do](#what-the-application-can-do)

:small_blue_diamond: [API Endpoints](#api-endpoints)

:small_blue_diamond: [Dependencies](#dependencies)

:small_blue_diamond: [How to Run the Application](#how-to-run-the-application)

:small_blue_diamond: [Extra Gems Used](#extra-gems-used)

:small_blue_diamond: [Entity-Relationship Diagram](#entity-relationship-diagram)

:small_blue_diamond: [Seeds](#seeds)

:small_blue_diamond: [Tests](#tests)

:small_blue_diamond: [Development Progress](#development-progress)

:small_blue_diamond: [License](#license)


## What the Application Can Do

:heavy_check_mark: Create account for buffet owners and clients

:heavy_check_mark: Register buffet

:heavy_check_mark: Register event types for buffet

:heavy_check_mark: Register payment options for buffet

:heavy_check_mark: Register prices for event types

:heavy_check_mark: Register, evaluate, confirm and cancel orders

:heavy_check_mark: List buffets

:heavy_check_mark: List buffet event types

:heavy_check_mark: List buffet payment options

:heavy_check_mark: List event type base prices

:heavy_check_mark: List orders

:heavy_check_mark: Search for buffets

:heavy_check_mark: Exchange messages on orders

## API Endpoints

### Buffet Details Endpoint

`GET /api/v1/buffets/{id}`

Returns buffet's id, brand name, phone, full address and description if the buffet id exists. Else, it returns `404 status`.

Response Example:

```
{
  "id": 1,
  "brand_name": "Buffet da Maria",
  "phone": "11987654321",
  "address": "Rua das Flores",
  "district": "Centro",
  "city": "São Paulo",
  "state": "SP",
  "cep": "02478150",
  "description": "Buffet especializado em festas infantis."
}
```

### Buffet List Endpoint

`GET /api/v1/buffets`

Returns a list of all buffets, with its id, brand name, phone, full address and description that exists in the system. If none exist, it returns an empty array.

Response Example:

```
[
  {
    "id": 1,
    "brand_name": "Buffet da Maria",
    "phone": "11987654321",
    "address": "Rua das Flores",
    "district": "Centro",
    "city": "São Paulo",
    "state": "SP",
    "cep": "02478150",
    "description": "Buffet especializado em festas infantis."
  },
  {
    "id": 2,
    "brand_name": "Buffet do João",
    "phone": "11976543210",
    "address": "Avenida Principal",
    "district": "Bairro Novo",
    "city": "Rio de Janeiro",
    "state": "RJ",
    "cep": "77829146",
    "description": "Buffet completo para casamentos e eventos corporativos."
  },
  {
    "id": 3,
    "brand_name": "Buffet Encantado",
    "phone": "1133333333",
    "address": "Rua das Estrelas",
    "district": "Jardim Primavera",
    "city": "Curitiba",
    "state": "PR",
    "cep": "69306398",
    "description": "O lugar perfeito para festas temáticas e eventos sociais."
  },
  {
    "id": 4,
    "brand_name": "Buffet Sabores do Brasil",
    "phone": "1144444444",
    "address": "Avenida Central",
    "district": "Centro",
    "city": "Brasília",
    "state": "DF",
    "cep": "69314142",
    "description": "Buffet especializado em culinária brasileira para eventos corporativos."
  },
  {
    "id": 5,
    "brand_name": "Buffet do Carlos",
    "phone": "1132323232",
    "address": "Praça das Árvores",
    "district": "Vila Verde",
    "city": "Porto Alegre",
    "state": "RS",
    "cep": "41253244",
    "description": "Buffet com cardápio variado para todos os tipos de eventos."
  }
]
```

### Buffet Query By Brand Name Endpoint

`GET /api/v1/buffets?query={brand_name}`

Returns a list of all buffets that have the informed query in his id, brand name, with its brand name, phone, full address and description. If none match the query, it returns an empty array.

Request Example:

```
`GET /api/v1/buffets?query=ar`
```

Response Example:

```
[
  {
    "id": 1,
    "brand_name": "Buffet da Maria",
    "phone": "11987654321",
    "address": "Rua das Flores",
    "district": "Centro",
    "city": "São Paulo",
    "state": "SP",
    "cep": "02478150",
    "description": "Buffet especializado em festas infantis."
  },
  {
    "id": 5,
    "brand_name": "Buffet do Carlos",
    "phone": "1132323232",
    "address": "Praça das Árvores",
    "district": "Vila Verde",
    "city": "Porto Alegre",
    "state": "RS",
    "cep": "41253244",
    "description": "Buffet com cardápio variado para todos os tipos de eventos."
  }
]
```

### Buffet Event Type List Endpoint

`GET /api/v1/buffets/1/event_types`

Returns a list of all buffet event types that exists in the system, with its id, name, description, minimum and maximum attendees, duration, menu and if it provides alcohol drinks, decoration, parking service or serves external address. If none exist, it returns an empty array.

Response Example:

```
[
  {
    "id": 1,
    "name": "Casamento",
    "description": "Celebração do amor entre duas pessoas.",
    "minimum_attendees": 50,
    "maximum_attendees": 200,
    "duration": 120,
    "menu": "Buffet completo com opções de carne, peixe e vegetariano.",
    "provides_alcohol_drinks": 1,
    "provides_decoration": 1,
    "provides_parking_service": 1,
    "serves_external_address": 0
  },
  {
    "id": 6,
    "name": "Festa de Noivado",
    "description": "Celebração do compromisso de casamento.",
    "minimum_attendees": 30,
    "maximum_attendees": 100,
    "duration": 80,
    "menu": "Canapés, bebidas e bolo comemorativo.",
    "provides_alcohol_drinks": 1,
    "provides_decoration": 1,
    "provides_parking_service": 1,
    "serves_external_address": 0
  },
  {
    "id": 11,
    "name": "Conferência",
    "description": "Evento de grande porte com palestras e workshops.",
    "minimum_attendees": 100,
    "maximum_attendees": 1000,
    "duration": 240,
    "menu": "Coffee breaks, almoços e jantares.",
    "provides_alcohol_drinks": 0,
    "provides_decoration": 0,
    "provides_parking_service": 1,
    "serves_external_address": 1
  },
  {
    "id": 16,
    "name": "Encontro Familiar",
    "description": "Reunião de familiares para confraternização.",
    "minimum_attendees": 10,
    "maximum_attendees": 100,
    "duration": 60,
    "menu": "Churrasco, saladas e sobremesas.",
    "provides_alcohol_drinks": 1,
    "provides_decoration": 0,
    "provides_parking_service": 1,
    "serves_external_address": 0
  }
]
```

### Event Type Availability Endpoint

`GET /api/v1/event_type/{id}?date={yyyy-mm-dd}&attendee_quantity={integer}`

Returns the event type is availability for the date informed. If yes, it also returns the preview prices based on its base-prices. If the event type doesn't exist, it returns `status 404` instead.

Request Example:

`GET /api/v1/event_types/1?date=2024-06-15&attendee_quantity=50`

Response Example:

```
{
  "available": true,
  "preview_prices": [
  {
    "description": "Meio de semana",
    "value": 1000.0
  },
  {
    "description": "Fim de semana",
    "value": 1500.0
  }
  ]
}
```

Request Example:

`GET /api/v1/event_types/1?date=2024-06-10&attendee_quantity=50`

Response Example:

```
{
  "available": false,
  "message": "Erro! O Buffet não está disponível para esta data."
}
```

If the parameters are invalid it returns a `422 status` informing its errors.

Request example:

`GET /api/v1/event_types/1?date=foo&attendee_quantity=bar`

Response example:

```
{
  "errors": [
    "Quantidade de Convidados precisa ser um número inteiro.",
    "Data precisa estar no formato yyyy-mm-dd."
  ]
}
```

**Also check my Vue.js app ([cade-buffet-vue](https://github.com/ruliancruz/cade-buffet-vue)) that consumes this API!**

## Dependencies

:warning: [Ruby 3.3.0](https://rvm.io/)

:warning: [SQLite3 1.4](https://www.sqlite.org/)

:warning: [Node.js](https://nodejs.org/)

:warning: [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/)

:warning: [Bundler](https://bundler.io/)

:warning: [Libvips42](https://packages.ubuntu.com/focal/libs/libvips42/)

:warning: [Rails 7.1.3.2](https://guides.rubyonrails.org/v5.0/getting_started.html)

## How to Run the Application

To run this application I suggest you to use an Unix-based system, my personal recommendation is the latest version of **[Ubuntu](https://ubuntu.com/)**. If you have get errors while trying to set up the application to run, check if the dependencies are present and in the correct versions.

First you need to install **Ruby** with at least **3.3.0** version, I recommend you to use a version manager, like [**RVM**](https://rvm.io/).

Next you need to install **Rails**, to do it, open your terminal and type:

```
gem install rails
```

After that, to install all gem dependencies you will need to install **Bundler**, running:

```
bundler install
```

You're also going to need **Libvips42** to correctly process images.

So, if you're using apt-get, type:

```
sudo apt install libvips42
```

After that, you'll have all dependencies.

Now, set up the database with:

```
rails db:setup
```

With that, you'll have the application ready to use.

To start the server type:

```
rails s
```

Now you can access the application through http://localhost:3000/ route.

## Extra Gems Used

This is automatically installed when you run Bundler, so you don't need to worry,

:gem: [cpf_cnpj](https://github.com/fnando/cpf_cnpj)

## Entity-Relationship Diagram

![Entity-relationship diagram](app/assets/images/entity_relationship_diagram.png)

## Seeds

The application has seeds to explore the system, it generates buffet owners, buffets, event types, base prices, payment options and a client. For orders and messages, you should register it using the app.

The seeds file is run on `rails db:setup`

All the data is fictional and generated by AI and random generators.

### Seeds Data

#### Client
| Field    | Value              |
|----------|--------------------|
| email    | client@example.com |
| password | password           |
| name     | João da Silva      |
| cpf      | 28142464020        |
<br>

#### Buffet Owners
| email              | password  |
|--------------------|-----------|
| owner1@example.com | password1 |
| owner2@example.com | password2 |
| owner3@example.com | password3 |
| owner4@example.com | password4 |
| owner5@example.com | password5 |
<br>

#### Buffets
| brand_name               | corporate_name         | cnpj           | phone       | address           | district         | city           | state | cep      | description                                                             | buffet_owner_id |
|--------------------------|------------------------|----------------|-------------|-------------------|------------------|----------------|-------|----------|-------------------------------------------------------------------------|-----------------|
| Buffet da Maria          | Maria Ltda             | 51995596000148 | 11987654321 | Rua das Flores    | Centro           | São Paulo      | SP    | 02478150 | Buffet especializado em festas infantis.                                | 1               |
| Buffet do João           | João Buffet            | 74896924000154 | 11976543210 | Avenida Principal | Bairro Novo      | Rio de Janeiro | RJ    | 77829146 | Buffet completo para casamentos e eventos corporativos.                 | 2               |
| Buffet Encantado         | Encantado Festas       | 94500187000136 | 1133333333  | Rua das Estrelas  | Jardim Primavera | Curitiba       | PR    | 69306398 | O lugar perfeito para festas temáticas e eventos sociais.               | 3               |
| Buffet Sabores do Brasil | Sabores do Brasil Ltda | 00255206000162 | 1144444444  | Avenida Central   | Centro           | Brasília       | DF    | 69314142 | Buffet especializado em culinária brasileira para eventos corporativos. | 4               |
| Buffet do Carlos         | Carlos & Cia           | 21132671000186 | 1132323232  | Praça das Árvores | Vila Verde       | Porto Alegre   | RS    | 41253244 | Buffet com cardápio variado para todos os tipos de eventos.             | 5               |
<br>

#### Event Types
| name                 | description                                                      | minimum_attendees | maximum_attendees | duration | menu                                                               | provides_alcohol_drinks | provides_decoration | provides_parking_service | serves_external_address | buffet_id |
|----------------------|------------------------------------------------------------------|-------------------|-------------------|----------|--------------------------------------------------------------------|-------------------------|---------------------|--------------------------|-------------------------|-----------|
| Casamento            | Celebração do amor entre duas pessoas.                           | 50                | 200               | 120      | Buffet completo com opções de carne, peixe e vegetariano.          | 1                       | 1                   | 1                        | 0                       | 1         |
| Aniversário Infantil | Festa para celebrar o aniversário de uma criança.                | 20                | 50                | 80       | Cardápio infantil com salgadinhos, doces e bolo decorado.          | 0                       | 1                   | 1                        | 0                       | 2         |
| Evento Corporativo   | Encontro de empresas para networking ou celebrações.             | 30                | 300               | 160      | Opções variadas de canapés, finger foods e bebidas.                | 1                       | 0                   | 1                        | 1                       | 3         |
| Chá de Bebê          | Celebração do próximo bebê que está para chegar.                 | 10                | 50                | 60       | Salgadinhos, bolos e doces diversos.                               | 0                       | 1                   | 1                        | 0                       | 4         |
| Formatura            | Celebração da conclusão de um curso ou etapa acadêmica.          | 50                | 200               | 100      | Buffet com opções de jantar e finger foods.                        | 1                       | 1                   | 1                        | 0                       | 5         |
| Festa de Noivado     | Celebração do compromisso de casamento.                          | 30                | 100               | 80       | Canapés, bebidas e bolo comemorativo.                              | 1                       | 1                   | 1                        | 0                       | 1         |
| Festa de Natal       | Celebração do Natal com amigos e familiares.                     | 20                | 150               | 120      | Ceia natalina com peru, tender, e acompanhamentos típicos.         | 1                       | 1                   | 1                        | 0                       | 2         |
| Evento Cultural      | Evento para promover a cultura, arte e entretenimento.           | 50                | 500               | 200      | Lanches, petiscos e bebidas variadas.                              | 0                       | 1                   | 1                        | 1                       | 3         |
| Festa de Reveillon   | Celebração do Ano Novo com fogos de artifício e festividades.    | 50                | 300               | 160      | Buffet completo com pratos especiais para a virada do ano.         | 1                       | 1                   | 1                        | 0                       | 4         |
| Festa Junina         | Celebrando as tradições juninas com comidas típicas e danças.    | 30                | 200               | 100      | Barracas com comidas típicas como milho verde, canjica, e quentão. | 0                       | 1                   | 1                        | 0                       | 5         |
| Conferência          | Evento de grande porte com palestras e workshops.                | 100               | 1000              | 240      | Coffee breaks, almoços e jantares.                                 | 0                       | 0                   | 1                        | 1                       | 1         |
| Festa Temática       | Celebração com tema específico, como anos 80 ou tropical.        | 20                | 100               | 80       | Comida e bebida relacionadas ao tema da festa.                     | 1                       | 1                   | 1                        | 0                       | 2         |
| Desfile de Moda      | Apresentação das últimas tendências de moda.                     | 50                | 500               | 120      | Petiscos e drinks especiais para os convidados.                    | 1                       | 0                   | 1                        | 1                       | 3         |
| Concerto             | Apresentação musical ao vivo.                                    | 50                | 500               | 80       | Petiscos e bebidas durante o intervalo.                            | 0                       | 0                   | 1                        | 1                       | 4         |
| Festa de Halloween   | Celebração do Dia das Bruxas com fantasias e decoração temática. | 20                | 150               | 100      | Petiscos assustadores e drinques especiais.                        | 1                       | 1                   | 1                        | 0                       | 5         |
| Encontro Familiar    | Reunião de familiares para confraternização.                     | 10                | 100               | 60       | Churrasco, saladas e sobremesas.                                   | 1                       | 0                   | 1                        | 0                       | 1         |
| Feira de Negócios    | Evento para promover produtos e serviços de empresas.            | 100               | 1000              | 160      | Coffee breaks e almoços.                                           | 0                       | 0                   | 1                        | 1                       | 2         |
| Festa da Empresa     | Celebração de conquistas e metas alcançadas.                     | 50                | 500               | 120      | Jantar completo e bebidas variadas.                                | 1                       | 1                   | 1                        | 0                       | 3         |
| Retiro Espiritual    | Encontro para reflexão e práticas espirituais.                   | 20                | 100               | 60       | Refeições leves e saudáveis.                                       | 0                       | 0                   | 1                        | 1                       | 4         |
| Festa de Carnaval    | Celebração do Carnaval com música e dança.                       | 30                | 200               | 100      | Petiscos típicos de Carnaval e bebidas refrescantes.               | 1                       | 1                   | 1                        | 0                       | 5         |
<br>

#### Payment Options
| name                   | installment_limit | buffet_id |
|------------------------|-------------------|-----------|
| Dinheiro               | 1                 | 1         |
| Cartão de Crédito      | 12                | 2         |
| Cartão de Débito       | 1                 | 3         |
| Transferência Bancária | 1                 | 4         |
| PIX                    | 1                 | 5         |
| Boleto Bancário        | 1                 | 1         |
| Cheque                 | 1                 | 2         |
| Vale-Alimentação       | 1                 | 3         |
| Vale-Refeição          | 1                 | 4         |
| PayPal                 | 1                 | 5         |
<br>

#### Base-prices
| Description     | Minimum | Additional per Person | Extra Hour Value | Event Type ID |
|-----------------|---------|-----------------------|------------------|---------------|
| Meio de semana  | 1000.0  | 30.0                  | 150.0            | 1             |
| Fim de semana   | 1500.0  | 40.0                  | 200.0            | 1             |
| Valor padrão    | 800.0   | 20.0                  | 120.0            | 2             |
| Meio de semana  | 1500.0  | 50.0                  | 200.0            | 3             |
| Fim de semana   | 2000.0  | 60.0                  | 250.0            | 3             |
| Valor padrão    | 600.0   | 15.0                  | 100.0            | 4             |
| Meio de semana  | 1200.0  | 40.0                  | 180.0            | 5             |
| Fim de semana   | 1800.0  | 50.0                  | 220.0            | 5             |
| Valor padrão    | 1000.0  | 30.0                  | 150.0            | 6             |
| Meio de semana  | 1800.0  | 50.0                  | 220.0            | 7             |
| Fim de semana   | 2500.0  | 60.0                  | 250.0            | 7             |
| Valor padrão    | 2000.0  | 70.0                  | 250.0            | 8             |
| Meio de semana  | 2500.0  | 80.0                  | 280.0            | 9             |
| Fim de semana   | 3000.0  | 90.0                  | 300.0            | 9             |
| Valor padrão    | 1200.0  | 30.0                  | 150.0            | 10            |
| Meio de semana  | 2500.0  | 100.0                 | 300.0            | 11            |
| Fim de semana   | 3500.0  | 120.0                 | 350.0            | 11            |
| Valor padrão    | 1000.0  | 30.0                  | 150.0            | 12            |
| Meio de semana  | 2000.0  | 80.0                  | 250.0            | 13            |
| Fim de semana   | 2500.0  | 90.0                  | 280.0            | 13            |
| Valor padrão    | 1500.0  | 60.0                  | 200.0            | 14            |
| Meio de semana  | 1200.0  | 40.0                  | 180.0            | 15            |
| Fim de semana   | 1800.0  | 50.0                  | 220.0            | 15            |
| Valor padrão    | 800.0   | 20.0                  | 120.0            | 16            |
| Meio de semana  | 2500.0  | 100.0                 | 300.0            | 17            |
| Fim de semana   | 3500.0  | 120.0                 | 350.0            | 17            |
| Valor padrão    | 2000.0  | 80.0                  | 250.0            | 18            |
| Meio de semana  | 600.0   | 15.0                  | 100.0            | 19            |
| Fim de semana   | 900.0   | 20.0                  | 120.0            | 19            |
| Meio de semana  | 1200.0  | 30.0                  | 150.0            | 20            |
| Fim de semana   | 1800.0  | 40.0                  | 180.0            | 20            |

## Tests

This project was made using Test Driven Development and has tests for system, requests and models.

You can run all the tests running `rspec` in the project directory on terminal.

## Development Progress

Main Application: `In progress`

API: `In progress`

Swagger: `Coming soon`

Deploy: `Coming soon`

## License

The [MIT License](https://github.com/ruliancruz/cade-buffet/blob/main/LICENSE)

Copyright ©️ 2024 - Cadê Buffet