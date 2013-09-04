// Genetic Algorithm to solve the Travelling Salesman problem
//
// by wenlong zhao

import java.applet.*;
import java.awt.*;

public class Genetic extends Applet implements Runnable {
 Canvas C = null;
 Dimension CD;
 Label L;
 Graphics GC;
 int Initial_population = 800;
 int Mating_population = Initial_population/2;
 int Favoured_population = Mating_population/2;
 int Number_cities = 30;
 int cut_length = Number_cities/5;
 double Mutation_probability = 0.10;

 double loops=1.5;
 int Epoch;
 double xlow = 0.0;
 double ylow = 0.0;
 double xhigh = 100.0;
 double yhigh = 100.0;
 double xrange, yrange;
 double min_cost = 5.0;
 double timestart,timend;
 Thread T = null;
 double costPerfect = 0.;

 boolean started = false;

 City [] cities;
 Chromosome [] chromosomes;

   public void init() {
    System.out.println("Initialise ...");
    setLayout(new BorderLayout());

    if(C == null) {
     C = new MyCanvas();
     add(C,"Center");
     L = new Label("Travelling Salesman problem using a Genetic Algorithm");
     add(L,"South");
    }
    this.show();
  }

   public void start() {

    System.out.println("Start ...");
    // generate a set of cities

    cities = new City[Number_cities];

    xrange = xhigh - xlow;
    yrange = yhigh - ylow;

    double phi = Math.random()*2.*Math.PI;
    double dphi = loops*Math.PI/(double)Number_cities;

    for(int i=0;i<Number_cities;i++) {
     //cities[i] = new City(xlow + Math.random()*(xhigh-xlow), ylow + Math.random()*(yhigh-ylow), xrange/2, yrange/2);

     double r = 0.5*xrange*(double)(i+1)/(double)Number_cities;
     phi += dphi;
     double xpos = xrange/2 + r*Math.cos(phi);
     double ypos = yrange/2 + r*Math.sin(phi);
     //double ypos = yrange/2 + 2*i;
     //double xpos = xrange/2 + i*i/7;
     cities[i] = new City(xpos, ypos, xrange/2, yrange/2);
    }

    Chromosome perfect = new Chromosome(Number_cities, cities);
    int cl [] = new int[Number_cities];
    for(int i=0;i<Number_cities;i++) cl[i] = i;
    perfect.set_cities(cl);
    perfect.calculate_cost(cities);
    System.out.println("Cost Perfect = "+perfect.get_cost());
    costPerfect = perfect.get_cost();

    // Randomise the order of the cities

    for(int i=0;i<Number_cities;i++) {
   int index1 = (int) ( 0.999999*Math.random()*(double)Number_cities);
     int index2 = (int) ( 0.999999*Math.random()*(double)Number_cities);
     // swap the positions

     City temp = cities[index2];
     cities[index2] = cities[index1];
     cities[index1] = temp;
    }
   

    // generate an initial population of chromosomes

    chromosomes = new Chromosome[Initial_population];

    for(int i=0;i<Initial_population;i++) {
     chromosomes[i] = new Chromosome(Number_cities, cities);
     chromosomes[i].set_cut(cut_length);
     chromosomes[i].set_mutation(Mutation_probability);
    }
    
    timestart = System.currentTimeMillis();
    timend = timestart;

    started = true;

    C.update(C.getGraphics());
    //while(timend - timestart < 5000.0) {timend = System.currentTimeMillis();}

    Sort_chromosomes(Initial_population);

   Epoch = 0;


  if(T != null) T = null;
  T = new Thread(this);
  T.setPriority(Thread.MIN_PRIORITY);
  T.start();
   }

   public void Sort_chromosomes(int num) {
    Chromosome ctemp;
    boolean swapped = true;
    while(swapped) {
     swapped = false;
     for(int i=0;i<num-1;i++) {
      if(chromosomes[i].get_cost() > chromosomes[i+1].get_cost() ) {
       ctemp = chromosomes[i];
       chromosomes[i] = chromosomes[i+1];
       chromosomes[i+1] = ctemp;
       swapped = true;
      }
     }
    }
   }

   public void run() {

    double this_cost = 500.0;
    double old_cost = 0.0;
    double dcost = 500.0;
    int count_same = 0;

    C.update(C.getGraphics());

//       while(this_cost > min_cost && Epoch < Number_cities*10000 ) {
    while(this_cost > costPerfect && count_same < 100) {

     Epoch++;

     int ioffset = Mating_population;
     int mutated = 0;


     // Mate the chromosomes in the favoured population with all in the mating population
     for(int i=0;i<Favoured_population;i++) {
      Chromosome cmother = chromosomes[i];
      // Select partner from the mating population
      int father = (int) ( 0.999999*Math.random()*(double)Mating_population);
      Chromosome cfather = chromosomes[father];

      mutated += cmother.mate(cfather,chromosomes[ioffset],chromosomes[ioffset+1]);
      ioffset += 2;
     }

     // The new generation of chromosomes is in position Mating_population ... move them
     // to the right place in the list and calculate their costs

     for(int i=0;i<Mating_population;i++) {
      chromosomes[i] = chromosomes[i+Mating_population];
      chromosomes[i].calculate_cost(cities);
     }


     // Now sort them

     Sort_chromosomes(Mating_population);

     double cost = chromosomes[0].get_cost();
     dcost = Math.abs(cost-this_cost);
     this_cost = cost;
     double mutation_rate = 100.0 * (double) mutated / (double) Mating_population;


     L.setText("Epoch "+Epoch+" Cost "+(int)this_cost+" Mutated "+mutation_rate+"% Count "+count_same);

     if((int)this_cost == (int)old_cost) {
      count_same++;
     } else {
      count_same = 0;
      old_cost = this_cost;
     }
     C.update(C.getGraphics());


    }
    L.setText("A solution found after "+Epoch+" epochs!");
     double timestart = System.currentTimeMillis();
  while(timend - timestart < 5000.0) timend = System.currentTimeMillis();
    start();
   }

   public class MyCanvas extends Canvas {

    public void paint(Graphics G) {
     update(G);
    }

    public void update(Graphics G) {
   CD = this.size();
   int width = CD.width;
   int height = CD.height;
   int xlast,ylast;
   double xc = (double) width / xrange;
   double yc = (double) height / yrange;
   G.setColor(new Color(0.0f,0.0f,0.2f));
   G.fillRect(0,0,width,height);

   G.setColor(Color.green);
   xlast = width/2;
   ylast = height/2;
   G.fillOval(xlast-5,ylast-5,10,10);

   if(!started) return;

   G.setColor(Color.red);
   for(int i=0;i<Number_cities;i++) {
    int xpos = (int) ((cities[i].get_xpos() - xlow)*xc);
    int ypos = (int) ((cities[i].get_ypos() - ylow)*yc);
    G.fillOval(xpos-3,ypos-3,6,6);
   }

   G.setColor(Color.yellow);
   for(int i=0;i<Number_cities;i++) {
    int icity = chromosomes[0].get_city(i);
    int xthis = (int) ((cities[icity].get_xpos() - xlow)*xc);
    int ythis = (int) ((cities[icity].get_ypos() - ylow)*yc);
    G.drawLine( xlast,ylast,xthis,ythis);
    xlast = xthis;
    ylast = ythis;

     }
    }

   }




//   public String getAppletInfo () {
//      return "Genetic by J.J.B.";
//   }
 
}

   class City {
  double xpos;
  double ypos;
  double distance_to_centre;
  
  City(double x, double y, double xcentre, double ycentre) {
   xpos = x;
   ypos = y;
   distance_to_centre = proximity(xcentre,ycentre);
   //System.out.println("New city at "+xpos+","+ypos);
  }

  double get_xpos() {
   return xpos;
  }
  double get_ypos() {
   return ypos;
  }

  double proximity(City cother) {
   double xdiff = xpos - cother.get_xpos();
   double ydiff = ypos - cother.get_ypos();
   return Math.sqrt( xdiff*xdiff + ydiff*ydiff );
  }
  double proximity(double x, double y) {
   double xdiff = xpos - x;
   double ydiff = ypos - y;
   return Math.sqrt( xdiff*xdiff + ydiff*ydiff );
  }

  double proximity() {
   return distance_to_centre;
  }

  
 }

 class Chromosome {
  int [] city_list;
  double cost;
  double Mutation_probability;
  int length;
  int cut_length;

  Chromosome(int sequence_length, City [] cities) {
   length = sequence_length;
   boolean taken[] = new boolean[length];
   city_list = new int[length];
   cost = 0.0;
   for(int i=0;i<length;i++) taken[i] = false;
   for(int i=0;i<length-1;i++) {
    int icandidate;
    do {
     icandidate = (int) ( 0.999999* Math.random() * (double) length );
    } while(taken[icandidate]);
    city_list[i] = icandidate;
    taken[icandidate] = true;
    if(i == length-2) {
     icandidate = 0;
     while(taken[icandidate]) icandidate++;
     city_list[i+1] = icandidate;
    }
   }
   calculate_cost(cities);
   cut_length = 1;
  }

  void calculate_cost(City [] cities) {
   cost = cities[city_list[0]].proximity();
   for(int i=0;i<length-1;i++) {
    double dist = cities[city_list[i]].proximity(cities[city_list[i+1]]);
    cost += dist;
   }
  }


  double get_cost() {
   return cost;
  }

  int get_city(int i) {
   return city_list[i];
  }

  void set_cities(int [] list) {
   for(int i=0;i<length;i++) {
    city_list[i] = list[i];
   }
  }

  void set_city(int index, int value) {
   city_list[index] = value;
  }

  void set_cut(int cut) {
   cut_length = cut;
  }

  void set_mutation(double prob) {
   Mutation_probability = prob;
  }

  void print() {
   System.out.print("chromosome: ");
   for(int i=0;i<length;i++) System.out.print(" "+city_list[i]);
   System.out.println(" ");
  }

  boolean check() {
   boolean taken[] = new boolean[length];
   for(int i=0;i<length;i++) taken[i] = false;
   for(int i=0;i<length;i++) taken[city_list[i]] = true;
   for(int i=0;i<length;i++) {
    if(!taken[i]) {
     System.out.print("Bad !"); print();
     return false;
    }
   }
   return true;
  }

  int mate(Chromosome father, Chromosome offspring1, Chromosome offspring2) {
   int cutpoint1 = (int) (0.999999*Math.random()*(double)(length-cut_length));
   int cutpoint2 = cutpoint1 + cut_length;

   //System.out.print("\nMother: "); print();
   //System.out.print("\nFather: "); father.print();
   //System.out.println("\nCutpoints: "+cutpoint1+" "+cutpoint2);

   boolean taken1 [] = new boolean[length];
   boolean taken2 [] = new boolean[length];
   int off1 [] = new int[length];
   int off2 [] = new int[length];

   for(int i=0;i<length;i++) {
    taken1[i] = false;
    taken2[i] = false;
   }

   for(int i=0;i<length;i++) {
    if(i<cutpoint1 || i>= cutpoint2) {
     off1[i] = -1;
     off2[i] = -1;
    } else {
     int imother = city_list[i];
     int ifather = father.get_city(i);
     off1[i] = ifather;
     off2[i] = imother;
     taken1[ifather] = true;
     taken2[imother] = true;
    }
   }

    
   //System.out.print("\nOff1  : "); offspring1.print();
   //System.out.print("\nOff2  : "); offspring2.print();

   for(int i=0;i<cutpoint1;i++) {
    if(off1[i] == -1) {
     for(int j=0;j<length;j++) {
      int imother = city_list[j];
      if(!taken1[imother]) {
       off1[i] = imother; 
       taken1[imother] = true;
       break;
      }
     }
    }
    if(off2[i] == -1) {
     for(int j=0;j<length;j++) {
      int ifather = father.get_city(j);
      if(!taken2[ifather]) {
       off2[i] = ifather;
       taken2[ifather] = true;
       break;
      }
     }
    }
   }
   for(int i=length-1;i>=cutpoint2;i--) {
    if(off1[i] == -1) {
     for(int j=length-1;j>=0;j--) {
      int imother = city_list[j];
      if(!taken1[imother]) {
       off1[i] = imother; 
       taken1[imother] = true;
       break;
      }
     }
    }
    if(off2[i] == -1) {
     for(int j=length-1;j>=0;j--) {
      int ifather = father.get_city(j);
      if(!taken2[ifather]) {
       off2[i] = ifather;
       taken2[ifather] = true;
       break;
      }
     }
    }
   }




   offspring1.set_cities(off1);
   offspring2.set_cities(off2);


   //System.out.print("\nOff1  : "); offspring1.print();
   //System.out.print("\nOff2  : "); offspring2.print();



   int mutate = 0;
   if(Math.random() < Mutation_probability) {
     int iswap1 = (int) (0.999999*Math.random()*(double)(length));
     int iswap2 = (int) (0.999999*Math.random()*(double)length);
     int i = off1[iswap1];
     off1[iswap1] = off1[iswap2];
     off1[iswap2] = i;
    mutate++;
   }
   if(Math.random() < Mutation_probability) {
     int iswap1 = (int) (0.999999*Math.random()*(double)(length));
     int iswap2 = (int) (0.999999*Math.random()*(double)length);
     int i = off2[iswap1];
     off2[iswap1] = off2[iswap2];
     off2[iswap2] = i;
    mutate++;
   }
   //System.out.print("\nOff1  : "); offspring1.print();
   //System.out.print("\nOff2  : "); offspring2.print();
   return mutate;
  }



  int oldmate(Chromosome father, Chromosome offspring1, Chromosome offspring2) {
   int cutpoint1 = (int) (0.999999*Math.random()*(double)(length-cut_length));
   int cutpoint2 = cutpoint1 + cut_length;
   //System.out.println("Cutpoints: "+cutpoint1+" "+cutpoint2);
   boolean taken1 [] = new boolean[length];
   boolean taken2 [] = new boolean[length];
   for(int i=0;i<length;i++) {
    taken1[i] = false;
    taken2[i] = false;
   }
   for(int i=0;i<length;i++) {
    int imother = city_list[i];
    int ifather = father.get_city(i);
    int icand = imother;
    if( i>=cutpoint1 && i<cutpoint2) icand = ifather;
    if(taken1[icand]) {
     icand = 0;
     while(taken1[icand]) icand++;
    }
    offspring1.set_city(i,icand);
    taken1[icand] = true;

    icand = ifather;
    if( i>=cutpoint1 && i<cutpoint2) icand = imother;
    if(taken2[icand]) {
     icand = 0;
     while(taken2[icand]) icand++;
    }
    offspring2.set_city(i,icand);
    taken2[icand] = true;
   }
   int mutate = 0;
   if(Math.random() < Mutation_probability) {
    int iswap1 = (int) (0.999999*Math.random()*(double)length);
    int iswap2 = (int) (0.999999*Math.random()*(double)length);
    int i = offspring1.get_city(iswap1);
    offspring1.set_city(iswap1,offspring1.get_city(iswap2));
    offspring1.set_city(iswap2,i);
    mutate++;
   }
   if(Math.random() < Mutation_probability) {
    int iswap1 = (int) (0.999999*Math.random()*(double)length);
    int iswap2 = (int) (0.999999*Math.random()*(double)length);
    int i = offspring2.get_city(iswap1);
    offspring2.set_city(iswap1,offspring2.get_city(iswap2));
    offspring2.set_city(iswap2,i);
    mutate++;
   }
   //System.out.print("\nMother: "); print();
   //System.out.print("\nFather: "); father.print();
   //System.out.print("\nOff1  : "); offspring1.print();
   //System.out.print("\nOff2  : "); offspring2.print();
   return mutate;
  }
 }
