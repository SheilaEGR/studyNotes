/* ********************************************************************
                          INSERTION SORT

PROCEDURE: we start with an empty left hand and the cards face down on
the table. We then remove one card at a time from the table and insert
it into the correct position in the left hand. To find the correct
position for a card, we compare it with each of the cards already in 
the hand, from right to left. At all times, the cards held in the left
hand are sorted, and these cards were originally the top cards of the
pile on the table.


PROCEDIMIENTO: comenzamos con la mano izquierda vacía y las cartas boca
abajo en la mesa. Tomamos una carta de la mesa a la vez y la insertamos
en la posición correcta en nuestra mano izquierda. Para encontrar la
posición correcta de la carta, la comparamos con cada una de las cartas
que ya se encuentran ordenadas en la mano, de derecha a izquierda. En
todo momento las cartas de la mano izquierda están ordenadas, mismas que
originalmente se encontraban desordenadas en la mesa.
******************************************************************** */

// MODIFY THESE TWO VALUES ONLY:
// If you want to see the process slowly, try with a few bars
// and a long delay time.

// MODIFICA SOLAMENTE ESTOS DOS VALORES:
// Si deseas observar el proceso lentamente, intenta usar pocas
// barras y un tiempo de retardo mayor.
int numBars = 100;
int delayTime = 100;


Bar[] bar;            // Elements int the array
int sortedIndex = 0;  // Elements already sorted

void setup()
{
  // Define the size of the screen
  size(640, 480);
  
  // The width of the bars depends on the number of bars
  // and the width of the screen
  float barWidth = float(width) / numBars;
  
  // Create the array of elements to be sorted
  bar = new Bar[numBars];
  for(int i=0; i<numBars; i++)
  {
    bar[i] = new Bar();
    bar[i].setBarWidth(barWidth);
    bar[i].setPosAsMultipleOfWidth(i);
  }
}

void draw()
{
  background(150);
  
  // While the elements are not yet sorted
  if(sortedIndex < numBars-1)
  {
    int indexToOrder = sortedIndex + 1;
    
    // INITIAL STATE: DISPLAY ORDERED ELEMENTS IN GREEN,
    // ELEMENT TO ORDER IN BLUE AND UNORDERED ELEMENTS
    // IN RED
    // -----> Ordered elements
    fill(0, 150, 0);
    for(int i=0; i<=sortedIndex; i++)
      bar[i].display();
    // -----> Element to sort
    fill(0, 0, 150);
    bar[indexToOrder].display();
    // -----> Unordered elements
    fill(150, 0, 0);
    for(int i=indexToOrder+1; i<numBars; i++)
      bar[i].display();
      
    delay(delayTime);
    
    
    // SECOND STATE: INSERT ELEMENT TO SORT IN ITS
    // CORRECT POSITION
    // -----> Find right position of element to sort
    int rightPosition = -1;
    for(int i=0; i<=sortedIndex; i++)
    {
      if(bar[i].compare(bar[indexToOrder]) > 0)
      {
        rightPosition = i;
        break;
      }
    }
    // -----> If the element to sort is not in the
    // right position
    if(rightPosition < indexToOrder && rightPosition >= 0)
    {
      // Save element's value in a temporal object
      float value = bar[indexToOrder].getValue();
      // Shift sorted elements after correct position
      // to the right
      for(int i=indexToOrder; i>rightPosition; i--)
        bar[i].setValue(bar[i-1]);
      // Insert the element in the correct position
      bar[rightPosition].setValue(value);
    }
    // Update the number of sorted elements
    sortedIndex++;
  }
  // When the elements are sorted, display them all
  // in green
  else
  {
    fill(0, 150, 0);
    for(int i=0; i<numBars; i++)
      bar[i].display();
  }
}
