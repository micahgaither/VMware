bestFreeSpace = 0;
bestDatastore = null;
dsCapacity = null;
dsFreeSpace = null;
percentFree = null;
for(i in Cluster.datastore){
     selectedDatastore = Cluster.datastore[i];
     if ( !selectedDatastore.name.toLowerCase().search(".*staging.*") ) {
          dsCapacity = selectedDatastore.summary.capacity / 1024 / 1024 / 1024;
          dsFreeSpace = selectedDatastore.summary.freeSpace / 1024 / 1024 / 1024;
          percentFree = dsFreeSpace / dsCapacity * 100;
         if ( percentFree > 25 ){
               if ( dsFreeSpace > bestFreeSpace ) {
                    bestFreeSpace = dsFreeSpace;
                    bestDatastore = selectedDatastore;
               }
          }
     }}
 
if ( bestDatastore==null ) {
     throw "No datastore found which has over 25% free space!";
}
 
return bestDatastore;
