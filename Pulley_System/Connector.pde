class Connector extends PVector { //each object has a designated connector - green orb - where other objects can attach to 
    Pulley connectedPulley;
    Rope connectedRope; 
    Hook connectedHook;
    Handle connectedHandle;

 //these boolConnected characteristics are helpful in determing which specific object is attached to the connector
    boolean boolConnectedPulley = false;
    boolean boolConnectedRope = false;
    boolean boolConnectedHook = false;
    boolean boolConnectedWeight = false;

    boolean occupied = false; 

    Connector(float x, float y) {
        super(x, y); //sets the coordinates
    }
}
