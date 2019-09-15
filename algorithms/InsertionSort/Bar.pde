class Bar{
  // PUBLIC ATTRIBUTES
  public float value;
  
  // PRIVATE ATTRIBUTES
  private float barWidth = 20;
  private float posX = 0;
  private float posY = 0;
  
  // CONSTRUCTORS
  Bar()
  {
    setValue(random(50, 400));
  }
  
  Bar(float value)
  {
    setValue(value);
  }
  
  // DRAWING
  public void display()
  {
    rect(posX, posY, barWidth, value);
  }
  
  // SET AND GET METHODS
  public void setValue(float value)
  {
    this.value = value;
    posY = height - this.value;
  }
  
  public void setValue(Bar other)
  {
    setValue(other.value);
  }
  
  public float getValue()
  {
    return value;
  }
  
  public void setBarWidth(float barWidth)
  {
    this.barWidth = barWidth;
  }
  
  public void setPosX(float posX)
  {
    this.posX = posX;
  }
  
  public void setPosAsMultipleOfWidth(int multiple)
  {
    this.posX = barWidth * multiple;
  }
  
  // COMPARISON
  public float compare(Bar other)
  {
    return (value - other.value);
  }
  
  public void swap(Bar other)
  {
    float tempValue = value;
    setValue(other.value);
    other.setValue(tempValue);
  }
}
