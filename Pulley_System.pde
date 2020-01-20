import g4p_controls.*;


ArrayList<Pulley> pulleys;
ArrayList<Rope> ropes;
ArrayList<Hook> hooks;

Weight weight;
Handle handle;
Pulley passenger; //our mouse is the taxi, the pulley is the passenger, dragging the mouse moves the passenger

boolean holdingRope;
boolean pulleyOccupied;
boolean weightOccupied;
boolean handleOccupied;
boolean systemValid;
boolean weightAttachedToPulley;

float ma; //mechanical advantage by default, in this simulation, only ma = 1 or ma = 2 systems will be achievable
int arrayIteration;
int round;

final int[] iterationOrder = {600, 750, 900};
final float radius = 50;
final float weightY = 950;
final int trashWidth = 75;
final int connectRadius = 20;
final int xShift = connectRadius;


void setup() {

    createGUI();

    background(0);
    size(1600, 1000);

    textAlign(CENTER);
    ellipseMode(RADIUS);
    rectMode(RADIUS);

    holdingRope = false;
    pulleyOccupied = false;
    weightOccupied = false;
    handleOccupied = false;
    systemValid = false;

    arrayIteration = 0;
    round = 0;

    pulleys = new ArrayList<Pulley>(); 
    ropes = new ArrayList<Rope>();
    hooks = new ArrayList<Hook>();

    weight = new Weight(width - 500, weightY);
    handle = new Handle(width - 400, 150);
    pulleys.add(new Pulley(width - 450, 60));


    for (int i=50; i<width - 400; i+=50) {
        hooks.add(new Hook(i, 0, true));
        hooks.add(new Hook(i, height, false)); //putting hooks onto the top and bottom of the screen
    }
    fixedSystem(); //set up the fixed-in-position pulley system
}


void draw() {
    strokeWeight(1);
    background(0);
    fill(255);

    staticBackground(); //draws the background which cannot move around - things like the hook, trashcan

    for (Pulley i : pulleys) { 
        i.create();
    }
    for (Hook i : hooks) { 
        i.create();
    }
    for (Rope i : ropes) { 
        i.create(i);
    }

    weight.create();
    handle.create();
}


void fixedSystem() { //this pulley has a handle attached to it, this system cannot be deleted or moved around freely

    passenger = pulleys.get(0);
    if (pulleyToHook()) {}

    Rope a = new Rope(passenger.connectRight.x, passenger.connectRight.y, passenger.connectRight.x, passenger.connectRight.y+100);
    a.connectStart.connectedPulley = passenger;
    a.connectStart.boolConnectedPulley = true;

    passenger.connectRight.occupied = true;
    passenger.connectRight.connectedRope = a; //pulley's connectRight is connected to this particular rope
    passenger.connectRight.boolConnectedRope = true;

    a.connectEnd.connectedHandle = handle;
    handle.connector.connectedRope = a;
    ropes.add(a);
}


void staticBackground() { //does not change or interact with anything
    fill(150);
    noStroke();
    rect(width - 200 - trashWidth, trashWidth, trashWidth, trashWidth);

    fill(green);
    textSize(30);
    text("RECYCLE", width - 200 - trashWidth, trashWidth );

    textSize(30);
    text("Pulley", width - 100, 180);
    text("Weight Slider", width - 100, 300);
    text("RESET", width - 100, 410);
}
