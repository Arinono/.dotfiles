{...}: {
  xdg.configFile.ctop = {
    target = "./ctop/config";
    text = ''
      [options]
        columns = "status,name,cpu,mem"
        filterStr = ""
        sortField = "name"

      [toggles]
        allContainers = true
        enableHeader = true
        fullRowCursor = true
        sortReversed = false
    '';
  };
}
