within Buildings.Media;
package Steam "Package of classes modeling steam"
  extends Modelica.Media.Water.WaterIF97_ph;

  redeclare model extends BaseProperties "Base properties"

  end BaseProperties;

annotation (Documentation(info="<html>
The steam model is designed for the 1st generation district heating system.
</html>"));
end Steam;
