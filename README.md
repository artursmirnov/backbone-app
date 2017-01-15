# Installation
---

Installation process for debian-based systems.

### Requirements
----

* PHP 5.5 or newer
* Any webserver: [Apache](installation.md#markdown-header-apache-settings), nginx etc.
* [Mysql](installation.md#markdown-header-mysql-databases)
* GIT
* Node.js & npm: [NVM](https://github.com/creationix/nvm)
* Ruby & Compass: [RVM](https://rvm.io) & [Compass gem](http://compass-style.org/install/)
* Brunch: `npm install -g brunch`

```
sudo su
apt-get install php5 apache2 mysql-server mysql-client php5-mysql git
```


#### PHP Libraries
* Intl
* Curl
* Composer
* PDO

~~~~
sudo su

apt-get install curl php5-curl php5-intl
~~~~

We don't store composer.phar in the git, so you need to download it manually and install to common bin directory

~~~~
sudo su
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin
chmod +x /usr/local/bin/composer.phar
mv /usr/local/bin/composer.phar /usr/local/bin/composer
~~~~

# Set up the project
----

### Configuration

Install vendors:

``` composer install ```

### Database
(run commands from project root)
- Create mysql database
    ``` php app/console doctrine:database:create ```
- Create database schema
    ``` php app/console doctrine:schema:create ```
- Load doctrine fixtures
    ``` php app/console doctrine:fixtures:load ```

# UI application

In order to build the UI application:
```
cd src/Client
brunch build --production
```
