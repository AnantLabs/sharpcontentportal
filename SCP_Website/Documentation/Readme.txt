SharpContent

For more details please see the SharpContent Installation Guide (downloadable from SharpContent.com)

Clean Installation

- .NET Framework 2.0 must be installed
- unzip package into C:\SharpContent
- create Virtual Directory in IIS called SharpContent which points to the directory where the SharpContent.webproj file exists )
- make sure you have default.aspx specified as a Default Document in IIS
- rename release.config -> web.config
- SQL Server 2000 or 2005
  - manually create SQL Server database named "SharpContent" ( using Enterprise Manager or your tool of choice )
  - set the connection string in web.config in TWO places ( ie. <add key="SiteSqlServer" value="Server=(local);Database=SharpContent;uid=;pwd=;" /> )
- the {Server}/NetworkService user account must have Read, Write, and Change Control of the root website directory and subdirectories ( this allows the application to create files/folders ) 
- browse to localhost/SharpContent in your web browser
- the application will automatically execute the necessary database scripts and provide feedback in the browser

Application Upgrades

- make sure you always backup your files/database before upgrading to a new version
- BACKUP your web.config file in the root of your site
- unzip the code over top of your existing application ( using the Overwrite and Use Folder Names options )
- rename release.config -> web.config
- merge any localized settings from your old web.config to the new web.config. These typically include:
  - connection strings ( SiteSqlServer )
  - machine keys ( validationKey and decryptionKey )
  - objectQualifier 
- browse to localhost/SharpContent in your web browser
- the application will automatically execute the necessary database scripts and provide feedback in the browser

