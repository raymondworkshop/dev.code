package codingtest;

/**
 * Class for the kernel parameters
 *
 */
public class KernelParams {
	/**
	 * Type of kernel; 
	 * = 1 linear,
	 * = 2 polynomial,
	 * = 3 Gaussian,
	 */
	public int kernel = 1;
	/** Parameter a and sigma */
	protected double a;
	/** Parameter b */
	protected double b;
	/** Parameter c */
	protected double c;
	public KernelParams(int k, double a, double b, double c) {
		this.kernel = k;
		this.a = a;
		this.b = b;
		this.c = c;
	}
	//linear is the default
	public KernelParams() {
		this(1,1,1,1);
	}
}
