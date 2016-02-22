package exercise;

public class merge {
	//
	public static void sort(Comparable[] a){
		Comparable[] aux = new Comparable[a.length];
		
		sort(a, aux, 0, a.length - 1);
	}
	
	
	private static void sort(Comparable[] a, Comparable[] aux, int lw, int hi){
		if(hi <= lw)
			return;
		
		int mid = lw + (hi - lw) /2;
		
		sort(a, aux, lw, mid);
		sort(a, aux, mid, hi);
		
		merge(a, aux, lw, mid, hi);
	}
	
	private static void merge(Comparable[] a, Comparable[] aux, int lw, int mid, int hi){
		for(int k = lw; k<= hi; k++){
			aux[k] = a[k];
		}
		
		// merge back
		int i = lw, j = mid+1;
		for(int k = lw; k<= hi; k++){
			if(i>mid)
				a[k] = aux[j++];
			else if (j>hi)
				a[k] = aux[i++];
			//else if(aux[j] < aux[i])
			//	a[k] = aux[j++];
			else
				a[k] = aux[i++];
				
		}
	}
	
	//test
	
	
}
