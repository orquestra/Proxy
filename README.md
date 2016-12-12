#Proxy

Proxy para requisições POST e Webservice/SOAP.

#Objetivo

Quando é necessário efetuar requisições client-side para URLs ou Webservices que estão em outro domínio pode ocorrer situações em que estas requisições sejam bloqueadas pelo navegador (por política de segurança do próprio navegador).
Uma forma de contornar essa restrição é ter proxies instalados no mesmo domínio em que o Orquestra BPMS está rodando.
As páginas proxy recebem o endereço final a ser acessado e retornam o conteúdo originalmente retornado pela URL que se passou por parâmetro.

##Requisições POST

Utilizar requisição no seguinte formato:

```
proxy.aspx?[url]
```

##Requisições Webservice

Utilizar requisição no seguinte formato:

```
webservice-proxy.aspx?[url]
```

