//ListFeature.java
//list practice
package generics;

import java.util.List;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Arrays;


public class ListFeatures
{
    static List fill(List<String> list)
    {
        list.add("rat");
        list.add("cat");
        list.add("dog");
        list.add("dog");
        

        return list;
        
    }

    public static void main(String[] args)
    {
        //default printing behavior provided via each container's toString() method
        List<String> lists = fill(new ArrayList<String>());
        System.out.println("1:" + lists);
        
        System.out.println("2:" + fill(new LinkedList<String>()));

        String s = lists.get(0);
        System.out.println("3:" + s + " " + lists.indexOf(s));
        
        String s1 = lists.remove(0);
        System.out.println("4:" + lists);

        lists.add(0, "cymric");
        System.out.println("5:" + lists);

        List<String> sublist = lists.subList(1,2);
        System.out.println("subList: " + sublist);
        System.out.println("6:" + lists.containsAll(sublist));

        List<String> copylist = new ArrayList<String>(lists);
        System.out.println("7:" + copylist);

        List<String> sublist1 = Arrays.asList(copylist.get(0), copylist.get(1));
        System.out.println("8:" + sublist1);

        //retainAll is an effective set intersection operation, depending on equals() method
        copylist.retainAll(sublist1);
        System.out.println("9:" + copylist);

        copylist.addAll(1,sublist1);
        System.out.println("10:" + copylist);
        
        copylist.set(1, "dog");
        System.out.println("11:" + copylist);

        System.out.println("12:" + copylist.isEmpty());
        copylist.clear();
        System.out.println("13:" + copylist.isEmpty());

        //convert the collection to an array using toArray()
        System.out.println("14:" + lists);
        for (String str : lists)
            System.out.print(str + " ");
        System.out.println();
        
        Object[] o = lists.toArray();
        System.out.println("14:" + o[1]);

    }
    
    
}

