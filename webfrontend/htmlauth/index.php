<html>
 <head>
  <title>InfNodGra</title>
 </head>
 <body>
 <?php echo '<p>Docker-Plugin: InfluxDB /  Node-Red / Grafana</p>'; ?>
	<br/>
	<br/>
	Experimentelle Installation der Docker Container zum testen und ausprobieren.

	<br/>
	<br/>
	InfluxDB läuft auf Port 8086 
	<br/>
	Benutzername: dbadmin
	<br/>
	Passwort: dbadmin
	<br/>
	<br/>
	Um eine Datenbank zu erstellen kann folgende Anweisung benutzt werden:
	<br/>
	<code>curl -i -XPOST "http://xxx.xxx.xxx.xxx:8086/query?u=dbadmin&p=dbadmin" --data-urlencode "q=CREATE DATABASE loxdb"</code>

	<br/>
	<br/>
	Node-Red läuft auf Port 1880 
	<br/>
	ohne Zugangskennung
	<br/>
	<br/>
	Um sich mit der Datenbank zu verbinden ist noch ein Plugin über das Menu "Palette verwalten" zu installieren
	<br/>
	node-red-contrib-influxdb
	<br/>
	node-red-dashboard
	<br/>
	<br/>
	Optional:
	<br/>
	node-red-node-openweathermap
	
	
	<br/>
	<br/>
	Grafana läuft auf Port 3000 
	<br/>
	Benutzername: admin
	<br/>
	Passwort: admin

	

	

 </body>
</html>