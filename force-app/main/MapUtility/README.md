# MapUtility
# Package versions
| Packagen | Version | Id| Promoted |
| --- | --- | --- | --- |
| Core | 1.0.0-2 | 04t2o000000yUVjAAM |yes |
| Core | 1.1.0-1 | 04t2o000000yUVyAAM |yes |
| Mapping | 1.0.0-2 | 04t2o000000yUVeAAM |yes| 
| Mapping | 1.1.0-2 | 04t2o000000yUW3AAM |no |

## installation order
 1. Core
 1. Mapping

## Installation via SFDX

    sfdx force:package:install --targetusername="<username> " --package="<version Id>" --wait 60

## Installation via URL

### Sandbox 

    https:/test.salesforce.com/packaging/installPackage.apexp?p0=<version Id>
    
### Production 

Note: only promoted versions can be installed into a production org

    https:/login.salesforce.com/packaging/installPackage.apexp?p0=<version Id>
