# README
Esta es la api RESTful de tuniversidad  en ruby on Rails.

## Dependencias
Recuerda usar un ambiente (gemset) de rvm y no la instalación de ruby de tu S.O.

* Ruby version = 2.4.0

* Rails version = 5.0.2

* Database: postgresql. Seguir instrucciones de [aca](https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-14-04) 

* solr search engine server (5.5.4).
##Comandos importantes

* Para cargar la BD: `rails db:create rails db:migrate`

* Para poblar la db con datos falsos: `populator=mock rails db:seed`

* Para poblar la db con datos del año pasado: `populator=csv csv_path=path/to/csvs rails db:seed`
 
* Para correr los tests: `rspec spec` 

* Instalar gemas: `bundle install`

* Iniciar server solr: `rails sunspot:solr:start` 
## Deploy instructions (development)
 
* Instalar rails en la maquina con rvm

* Instalar java 8 y solr [este tutorial funciona](http://www.artur-rodrigues.com/tech/2015/09/21/taking-solr-5-and-sunspot-rails-to-production.html)

* Deployar desde maquina de desarrollo: `cap development deploy`

* Esperar lo mejor.

##Deploy instructions (production)

* TODO


## Detalles sobre solr

* Logs : /var/solr/logs

* Para empezar el server : `sudo service solr start`

+ Status del server: `sudo service solr status`

+ Tanto el instalador como los comandos para iniciar el server no son informativos de errores
asi que simpre revisar los logs.

* Para instalar en deploy hay que seguir el tutorial de arriba, excepto porque es 
necesario eliminar el archivo `managed-schema` de la carpeta  `conf` de la coleccion y
reemplazarlo por el `schema.xml` que se menciona en el tutorial.
