within Buildings.Media.Steam;
model testDifferentiation

equation

  aux = Buildings.Media.Steam.waterBaseProp_pT(p=101325, T=T);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end testDifferentiation;
