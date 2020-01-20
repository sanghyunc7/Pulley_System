class Items { //super class

    Connector drag; 
    Connector position;
    
    int connectWidth = 20;

    Items (float x, float y) {
        position = new Connector(x, y);
    }

    void drag(float x, float y) { //new Position

        drag = new Connector(x, y);
        this.position.set(drag);
    }
}

class Pulley extends Items {

    Connector connectLeft; //each pulley has four connectors, left/right/top/bottom
    Connector connectRight;    
    Connector connectTop;
    Connector connectBottom;

    Pulley(float x, float y) {
        super(x, y);

        connectLeft = new Connector(x-radius, y);
        connectRight = new Connector(x+radius, y);    
        connectTop = new Connector(x, y-radius);
        connectBottom = new Connector(x, y+radius);
    }

    boolean connectStartOnPulley (Rope a) { //checks if the rope's starting point is on the pulley
        if (a.connectStart.boolConnectedPulley) {
            if (a.connectStart.connectedPulley.equals(this)) {
                return true;
            } 
            return false;
        } 
        return false;
    }

    boolean connectEndOnPulley (Rope a) {
        if (a.connectEnd.boolConnectedPulley) {
            if (a.connectEnd.connectedPulley.equals(this)) {
                return true;
            } 
            return false;
        } 
        return false;
    }

    void drag(float x, float y) { //when user drags the pulley on gui, the event-based connectors also move around
        super.drag(x, y);

        connectLeft.set(drag.x-radius, drag.y);
        connectRight.set(drag.x+radius, drag.y);
        connectTop.set(drag.x, drag.y-radius); //revise
        connectBottom.set(drag.x, drag.y+radius);


//if we are moving a pulley, the rope connections associated with the pulley must be updated too
        if (this.connectLeft.boolConnectedRope) { 
            Rope a = this.connectLeft.connectedRope;

            if (connectStartOnPulley(a)) {
                a.connectStart.set(this.connectLeft);
            }
            if (connectEndOnPulley(a)) {
                a.connectEnd.set(this.connectLeft);
            }
        }

        if (this.connectRight.boolConnectedRope) {
            Rope a = this.connectRight.connectedRope;

            if (connectStartOnPulley(a)) {
                a.connectStart.set(this.connectRight);
            }
            if (connectEndOnPulley(a)) {
                a.connectEnd.set(this.connectRight);
            }
        }

        if (this.connectTop.boolConnectedRope) {
            Rope a = this.connectTop.connectedRope;

            if (connectStartOnPulley(a)) {
                a.connectStart.set(this.connectTop);
            }
            if (connectEndOnPulley(a)) {
                a.connectEnd.set(this.connectTop);
            }
        }

        if (this.connectBottom.boolConnectedRope) {
            Rope a = this.connectBottom.connectedRope;

            if (connectStartOnPulley(a)) {
                a.connectStart.set(this.connectBottom);
            }
            if (connectEndOnPulley(a)) {
                a.connectEnd.set(this.connectBottom);
            }
        }
    }

    void create() { //animates it to the screen
        //made of two parts: a circle and a rectangle through it

        noStroke();
        if (pulleys.get(0).equals(this)) {
            fill(purple); //purple to indicate that this is a special non-movable pulley
        } else {
            fill(red);
        }
        ellipse(this.position.x, this.position.y, radius, radius);

        fill(blue); //animate rectangle portion
        rect(this.position.x, this.position.y, radius/5, radius);

        fill(green); //animate connectors
        ellipse(this.connectTop.x, this.connectTop.y, 10, 10); 
        ellipse(this.connectBottom.x, this.connectBottom.y, 10, 10); 
        ellipse(this.connectLeft.x, this.connectLeft.y, 10, 10); 
        ellipse(this.connectRight.x, this.connectRight.y, 10, 10);
    }
}

class Rope extends Items {  

    Connector connectStart;
    Connector connectEnd;

    Rope(float x, float y, float x2, float y2) {
        super(x, y);   

        connectStart = new Connector(x, y);
        connectEnd = new Connector(x2, y2);
    }

    void drag(float x, float y) { //when user drags the pulley on gui, the event-based connectors also move around
        super.drag(x, y);

        connectStart.set(drag);
        connectEnd.set(drag);
    }

    void create(Rope a) {

        boolean cut = false; //because the heirarchy of if, else if, else conditions get convoluted with more complicated logistics, use this boolean condition 

        strokeWeight(4);
        stroke(red);
        
        if (holdingRope && ropes.indexOf(a) == ropes.size()-1) { //if i am holding this rope and it is the rope added to the arraylist

            if (a.connectStart.boolConnectedWeight) { //a pulley system is valid only if the rope attached to the weight rises up perpendicularly
                line(connectStart.x, connectStart.y, connectEnd.x, mouseY);
                cut = true;
            } 
            if (a.connectEnd.boolConnectedWeight) {
                line(connectStart.x, connectStart.y, connectEnd.x, mouseY);
                cut = true;
            }
            if (a.connectStart.boolConnectedPulley && !cut) { //if the rope is connected to a pulley
                if (a.connectStart.connectedPulley.connectBottom.boolConnectedWeight) { //if that pulley happens to be attached to a weight at the bottom
                    line(connectStart.x, connectStart.y, connectStart.x, mouseY); //again, the rope must rise perpendicularly
                    cut = true;
                }
            } 
            if (!cut) { //the end of the rope will be where your mouse is pointing
                line(connectStart.x, connectStart.y, mouseX, mouseY);
                cut = true;
            }
        } 
        if (!cut) { //it will fixate in place if we are no longer holding a rope (which is done by clicking on a connector
            line(connectStart.x, connectStart.y, connectEnd.x, connectEnd.y);
            cut = true;
        }
    }
}

class Hook extends Items { //the hooks that are permanently attached to the ground or the ceiling
    //does not have drag component, these hooks are fixed

    Connector connectTip;

    int hookHeight = 20;
    int hookWidth =  10;


    Hook(float x, float y, boolean ceiling) {
        super(x, y);

        if (ceiling) { //if the hook is on the ceiling
            connectTip = new Connector(x, y + hookHeight/2);
        } else { //or on the bottom
            connectTip = new Connector(x, y - hookHeight/2);
        }
    }

    void create() {
        fill(wood);
        rect(this.position.x, this.position.y, hookWidth, hookHeight);
        fill(green);
        ellipse(this.connectTip.x, this.connectTip.y, 10, 10);
    }
}

class Weight extends Items {

    int newtons = 50;
    int appliedForce = 0; //this value is the amount of force that the handle is exerting to lift the weight up
    int weightHeight = 100; //this is not dependent on radius, revise?
    int weightWidth = 80;

    Connector connectTop;

    Weight(float x, float y) {
        super(x, y);
        connectTop = new Connector(x, y - radius);
    }

    void drag(float x, float y) { //if we move the weight
        super.drag(x, y);
        connectTop.set(drag.x, y - weightHeight/2);

        if (connectTop.boolConnectedRope) {
            if (connectTop.connectedRope.connectStart.boolConnectedWeight) {
                connectTop.connectedRope.connectStart.set(connectTop); //update the connected rope's position
            }
            else if (connectTop.connectedRope.connectEnd.boolConnectedWeight) {
                connectTop.connectedRope.connectEnd.set(connectTop);
            }
        }  
          
        else if (connectTop.boolConnectedPulley) { //update the connected pulley's position
            this.connectTop.connectedPulley.drag(this.connectTop.x, this.connectTop.y - radius);
        }
    }

    void create() {
        fill(150);
        noStroke();
        rect(this.position.x, this.position.y, weightWidth/2, radius);
        fill(green);
        ellipse(this.connectTop.x, this.connectTop.y, 10, 10);
        textSize(20);
        text(newtons+ " N", this.position.x, this.position.y);


        textSize(30);
        text("APPLIED", width - 100, 50);
        text(appliedForce + "  Newtons", width - 100, 100);
    }
}

class Handle extends Items {

    Connector connector;

    float initX = 800;
    float initY = 150;

    Handle(float x, float y) {
        super(x, y);

        initX = x;
        initY = y;

        connector = new Connector(x, y);
    }

    void drag(float x, float y) {

        super.drag(x, y);

        this.connector.connectedRope.connectEnd.set(x, y);
    }
    void create() {
        fill(purple);
        ellipse(this.position.x, this.position.y, 25, 25);
    }
}
