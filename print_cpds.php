<?php
/*
requires as argument the name of the metadata sheet.
metadata sheet should be exported to tab-delimited .txt file and
formatted like this: dmrec TAB filename TAB title TAB [and whatever out here]
*/

$lines = file($argv[1]);
$f;
$string = "";
foreach($lines as $line){
    
    $parts = explode("\t", $line); 
    if (strpos($parts[1], "cpd") !== FALSE){
    
      if ($f != null && get_resource_type($f) === 'stream'){
        
        fwrite($f, "</cpd>");
        fclose($f);
        }
      $f = fopen($parts[1], 'w');
      fwrite($f, "<?xml version='1.0'?><cpd><type>Folder</type>\n");
      $string = "";
      }//if directory
      else {
            $string = make_page($parts[2], $parts[1], $parts[0]);
            fwrite($f, $string);
        }
        
     }//for


function make_page($title,$file, $dmrec){
    
    $string .= "<page><pagetitle>" . $title . "</pagetitle>\n";
    $string .= "<pagefile>" . $file . "</pagefile>\n";
    $string .= "<pageptr>" . $dmrec . "</pageptr></page>\n";
    return $string;
}
?>
        
     