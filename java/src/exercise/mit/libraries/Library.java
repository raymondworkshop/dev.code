package exercise.mit.libraries;
import java.util.ArrayList; //support dynamic arrays
//import java.util.List;

public class Library {
    // object field
    private String address;
    // the open hours - class fields
    private static String start = "9am"; 
    private static String end = "5pm";
    
    //int size;
    private ArrayList<Book> lib = new ArrayList<Book>();
    
    Library(String addr){
        address = addr;
    }
    
    public static void printOpeningHours(){
        System.out.println("Libraries are open daily from " + start + " to " + end + ".");
    }
    
    public void printAddress(){
        //return address;
        System.out.println(address);
    }
    
    
    public void addBook(Book book){
        lib.add(book);
    }
    
    public void borrowBook(String bookName){
        boolean bookTag = false;
        
        for(Book book : lib){
            String name = book.getTitle();
            //System.out.println(name);
            
            if (name.equals(bookName)){ //including the name in the lib
                if (book.isBorrowed()) {
                System.out.println("Sorry, this book is already borrowed.");
                
                } else {
                    //
                    book.borrowed(); // mark the borrowed status
                    System.out.println("You successfully borrowed " + name);
                }
                
               bookTag = true;
               break;
            }/* else {
                System.out.println("Borrowed? " + name + " " + book.isBorrowed());
            }*/
        }
        
        if (!bookTag) {
            System.out.println("Sorry, this book is not in our catalog.");
        }
    }
    
    public void printAvailableBooks(){
        if(!lib.isEmpty()){
          for(Book book : lib){
            if(!book.isBorrowed()){
                System.out.println(book.getTitle());
            }
          }
          
        } else {
            System.out.println("No book in catalog");
        }
    }
    
    public void returnBook(String bookName){
        for(Book book : lib){
            String name = book.getTitle();
            if(name.equals(bookName)){
                book.returned();
                System.out.println("You successfully returned " + bookName);
            }
        }
    }
    
    public static void main(String[] args) {
        // Create two libraries
        Library firstLibrary = new Library("10 Main St.");
        Library secondLibrary = new Library("228 Liberty St.");

        // Add four books to the first library
        firstLibrary.addBook(new Book("The Da Vinci Code"));
        firstLibrary.addBook(new Book("Le Petit Prince"));
        firstLibrary.addBook(new Book("A Tale of Two Cities"));
        firstLibrary.addBook(new Book("The Lord of the Rings"));
        //secondLibrary.addBook(new Book("The Lord of the Rings"));
        
        // Print opening hours and the addresses
        System.out.println("Library hours:");
        printOpeningHours();
        System.out.println();

        System.out.println("Library addresses:");
        firstLibrary.printAddress();
        secondLibrary.printAddress();
        System.out.println();
       
        // Try to borrow The Lords of the Rings from both libraries
        System.out.println("Borrowing The Lord of the Rings:");
        firstLibrary.borrowBook("The Lord of the Rings");
        firstLibrary.borrowBook("The Lord of the Rings");
        secondLibrary.borrowBook("The Lord of the Rings");
        System.out.println();
        
        // Print the titles of all available books from both libraries
        System.out.println("Books available in the first library:");
        firstLibrary.printAvailableBooks();
        System.out.println();
        System.out.println("Books available in the second library:");
        secondLibrary.printAvailableBooks();
        System.out.println();
        
      
        // Return The Lords of the Rings to the first library
        System.out.println("Returning The Lord of the Rings:");
        firstLibrary.returnBook("The Lord of the Rings");
        System.out.println();
        
        // Print the titles of available from the first library
        System.out.println("Books available in the first library:");
        firstLibrary.printAvailableBooks();
             
    }
}
