package com.example.locationfinder;

import android.graphics.drawable.Drawable;

import java.text.DecimalFormat;
import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Canvas;
import android.location.Location;
import android.widget.Toast;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;
//import com.readystatesoftware.mapviewballoons.BalloonItemizedOverlay;

public class LocationfinderOverlay extends ItemizedOverlay<OverlayItem> {
	
	private ArrayList<OverlayItem> mOverlays = new ArrayList<OverlayItem>();
	
	private Context mContext;
	
	private Location currentLocation;

	public LocationfinderOverlay(Drawable defaultMarker, Context context) {
		
		super(boundCenterBottom(defaultMarker));
		mContext = context;
		// TODO Auto-generated constructor stub
	}
	
	public void addOverlay(OverlayItem overlay){
		mOverlays.add(overlay);
		populate();
	}

	@Override
	protected OverlayItem createItem(int i){
		return mOverlays.get(i);
	}
	
	@Override
	public int size(){
		return mOverlays.size();
	}
	
//	public LocationfinderOverlay(Drawable defaultMarker, Context context){
//		super(boundCenterBottom(defaultMarker));
//		mContext = context;
//	}
	
	public void setCurrentLocation(Location loc){
		this.currentLocation = loc;
	}
	
	@Override
	protected boolean onTap(int index){
		OverlayItem item = mOverlays.get(index);
		AlertDialog.Builder dialog = new AlertDialog.Builder(mContext);
		dialog.setTitle(item.getTitle());
		dialog.setMessage(item.getSnippet());
		dialog.show();
		return true;
	}
	
//	GeoPoint point = new GeoPoint(19240000, -99120000);
//	OverlayItem overlayitem = new OverlayItem(point,"Hola","I'm in Hong Kong");
	
//	itemIzedoverlay.addOverlay(OverlayItem);
//	mapOverlays.add(itemizedoverlay);
	
//	public Location convertGpToLoc(GeoPoint gp){
//		Location convertedLocation = new Location("");
		
//		convertedLocation.setLatitude(gp.getLatitudeE6() / 1e6);
//		convertedLocation.setLongitude(gp.getLongitudeE6() / 1e6);
		
//		return convertedLocation;
//	}
	
//	@Override
//	protected boolean onBalloonTap(int index, OverlayItem item){
//		String tmp = mOverlays.get(index).getTitle();
		
//		GeoPoint mallPoint = mOverlays.get(index).getPoint();
		
//		Location tmpLoc = convertGpToLoc(mallPoint);
		
//		double distance = ((currentLocation).distanceTo(tmpLoc))*(0.000621371192);
		
//		DecimalFormat df = new DecimalFormat("#.##");
//		tmp = tmp + " is " + String.valueOf(df.format(distance)) + " miles away."
//		Toast.makeText(mContext,tmp,Toast.LENGTH_LONG).show();
 //       return true;
//	}
	
}
