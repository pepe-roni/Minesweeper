import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
public int NUM_ROWS=20;
public int NUM_COLS=20;
public int nBombs = 100;
public int mode=0;


void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  //your code to declare and initialize buttons goes here
  bombs = new ArrayList<MSButton>();
  buttons = new MSButton [20][20];
  for (int i=0; i<NUM_ROWS; i++)
  {
    for (int x=0; x<NUM_COLS; x++)
      buttons[i][x] = new MSButton(i, x);
  }
  setBombs();
}
public void setBombs()
{
  int numB = 0;
  while (numB < nBombs) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[r][c])) {
      bombs.add(buttons[r][c]);
      numB ++;
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon())
    displayWinningMessage();
  if (mode == 1)
  {
    textSize(20);
    stroke(255, 0, 0); 
    text("You Win", 200, 200);
  }
  if(mode ==2)
  {
     textSize(20);
  stroke(255, 0, 0); 
  background(255);
  text("You Lose",20, 20); 
  }
}
public boolean isWon()
{
  for (int r = 0; r< NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)
      if (bombs.contains(buttons[r][c]) && !buttons[r][c].isMarked())
      {
        mode=2;
        return false;
      }
  mode=1;
  return true;
}
public void displayLosingMessage()
{
  textSize(20);
  stroke(255, 255, 0);
  text("You Lose", 200, 200);
}
public void displayWinningMessage()
{
  textSize(20);
  stroke(255, 0, 0); 
  text("You Win", 200, 200);
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
    clicked = true;
    if (keyPressed == true)
      marked = !marked;
    else if (bombs.contains(this))
      displayLosingMessage();
    else if (countBombs(r, c) >0)
      setLabel(str(countBombs(r, c)));
    else
    {
      if (isValid(r, c+1) && !buttons[r][c+1].isClicked())
        buttons[r][c+1].mousePressed();
      if (isValid(r+1, c+1) && !buttons[r+1][c+1].isClicked())
        buttons[r+1][c+1].mousePressed();
      if (isValid(r+1, c) && !buttons[r+1][c].isClicked())
        buttons[r+1][c].mousePressed();
      if (isValid(r+1, c-1) && !buttons[r+1][c-1].isClicked())
        buttons[r+1][c-1].mousePressed();
      if (isValid(r, c-1) && !buttons[r][c-1].isClicked())
        buttons[r][c-1].mousePressed();
      if (isValid(r-1, c-1) && !buttons[r-1][c-1].isClicked())
        buttons[r-1][c-1].mousePressed();
      if (isValid(r-1, c) && !buttons[r-1][c].isClicked())
        buttons[r-1][c].mousePressed();
      if (isValid(r-1, c+1) && !buttons[r-1][c+1].isClicked())
        buttons[r-1][c+1].mousePressed();
    }
  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 20, 20);
    else if (clicked)
      fill(200);
    else 
      fill(100);

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r >= 0 && r < NUM_ROWS)
      if (c >=0 && c < NUM_COLS)
        return true;
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    if (isValid(row -1, col) && bombs.contains(buttons[row -1][col]))
      numBombs = numBombs +1;
    if (isValid(row -1, col +1) && bombs.contains(buttons[row -1][col+1]))
      numBombs = numBombs +1;
    if (isValid(row, col +1) && bombs.contains(buttons[row ][col+1]))
      numBombs = numBombs +1;
    if (isValid(row +1, col +1) && bombs.contains(buttons[row +1][col+1]))
      numBombs = numBombs +1;
    if (isValid(row +1, col) && bombs.contains(buttons[row +1][col]))
      numBombs = numBombs +1;
    if (isValid(row +1, col -1) && bombs.contains(buttons[row +1][col-1]))
      numBombs = numBombs +1;
    if (isValid(row, col -1) && bombs.contains(buttons[row ][col-1]))
      numBombs = numBombs +1;
    if (isValid(row -1, col -1) && bombs.contains(buttons[row -1][col-1]))
      numBombs = numBombs +1;
    return numBombs;
  }
}

