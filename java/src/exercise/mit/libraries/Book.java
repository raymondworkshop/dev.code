package exercise.mit.libraries;

public class Book {
    private String title;
    private boolean borrowed;
    
    // a new Book
    public Book(String bookTitle){
        title = bookTitle;
    }
    
    //mark the book as rented
    public void borrowed(){
        borrowed = true;
    }
    
    //not rented
    public void returned(){
        borrowed = false;
    }
    
    // returns true if the book is rented, false otherwise
    public boolean isBorrowed(){
        return borrowed;
    }
    
    // 
    public String getTitle(){
        return title;
    }
    
    //test
    public static void main(String[] args){
        Book example = new Book("The Da Vinci Code");
        System.out.println("Title (should be The Da Vinci Code): " + example.getTitle());
        System.out.println("Borrowed? (should be false): " + example.isBorrowed());
        example.borrowed();
        System.out.println("Borrowed? (should be true): " + example.isBorrowed());
        example.returned();
        System.out.println("Borrowed? (should be false): " + example.isBorrowed());
    }

}
