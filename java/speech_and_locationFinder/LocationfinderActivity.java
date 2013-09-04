package com.example.locationfinder;
//import com.example.speechrecandsyn.R;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.speech.RecognizerIntent;
import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;
import android.util.Log;

import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import android.widget.Toast;
import android.graphics.drawable.Drawable;


import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class LocationfinderActivity extends MapActivity implements LocationListener,OnClickListener, OnInitListener{

    private static final int REQUEST_CODE= 1111;
    private ListView wordsList;
    
	// an instance variable for TTS object
	private TextToSpeech tts;
	
	private Button btnSpeak;
	private EditText txtText;
	
	
	private MapController mapController;
    private MapView mapView;
    private Context mContext;
    
    private LocationManager locationManager;
    private GeoPoint currentPoint;
    private Location currentLocation = null;
    private LocationfinderOverlay currPos;
    
	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_locationfinder);
    
        Button speakButton= (Button) findViewById(R.id.speakButton);
        wordsList = (ListView) findViewById(R.id.list);
        
        //enable button if there is recognition service
        PackageManager pm = getPackageManager();
        List<ResolveInfo> activities = pm.queryIntentActivities(new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH),0);
        
        if(activities.size() != 0) {
        //	speakButton.setEnabled(false);
        //	speakButton.setText("Recognizer not present");
       // } else {
        	
        	speakButton.setText("Speak");
        }
        
        
        // for tts
        tts = new TextToSpeech(this, this);
        
        // get the reference to the button of speak for tts
        btnSpeak = (Button)findViewById(R.id.voice);
        
        txtText =(EditText) findViewById(R.id.enter);
        
        // listen for clicks
        btnSpeak.setOnClickListener(new View.OnClickListener() {
        	
        	@Override
        	public void onClick(View arg0){
        		speakOut();
        	}
        });
        
        
        
        
        mapView = (MapView) findViewById(R.id.mapView);
        mapView.setBuiltInZoomControls(true);
        mapView.setSatellite(false);
        mapController = mapView.getController();
        mapController.setZoom(15);

       getLastLocation();
      
       drawCurPositionOverlay();
	   animateToCurrentLocation();
	
	   
	   onResume();
	    // get current location
	   // String provider = getBestProvider(); 
	   // currentLocation = locationManager.getLastKnownLocation(provider);
	    
	   // if(currentLocation != null){
	    	// get list of overlays available in the map

		//    onLocationChanged(currentLocation);
	    	
	    	//add the mark to the overlay
		   
	   // }
	    
	   // locationManager.requestLocationUpdates(provider, 1000, 0, this);
	    
	    // itemizedoverlay.addOverlay(overlayitem);
	    //mapOverlays.add(itemizedoverlay);
	}
    
	 // when the button is clicked
    public void speakButtonClicked(View v){
    	startVoiceRecognitionActivity();
    	
    }
    
    // have an intent to start
    private void startVoiceRecognitionActivity(){
    	
    	Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
    	// indicate package
    	intent.putExtra(RecognizerIntent.EXTRA_CALLING_PACKAGE,getClass().getPackage().getName());
    	// display while listening
    	intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Saying a word!");
    	// set speech model
    	intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        // number of results to retrieve
    	intent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS,3);
    	// begin listening
    	startActivityForResult(intent,REQUEST_CODE);
    }
    
    // handle the results
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
    	if(requestCode == REQUEST_CODE && resultCode == RESULT_OK) {
    		
    		// populate the wordslist
    		ArrayList<String> matches = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
    		wordsList.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, matches));
    	}
    	super.onActivityResult(requestCode, resultCode, data);
    }
    
   // for tts 
   @Override
   public void onDestroy(){
	   // shutdown tts
	   if(tts != null){
		   tts.shutdown();
	   }
	   super.onDestroy();
   }
    
   @Override
   public void onInit(int initStatus){
		// check for successful instantiation
		if (initStatus == TextToSpeech.SUCCESS){
			
			int result = tts.setLanguage(Locale.getDefault());
			
			if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED){
				
				Log.e("TTS","This language is not supported");
			}else {
				btnSpeak.setEnabled(true);
				speakOut();
			}
			
		} else {
			Log.e("TTS", "Initilization Failed!");
		}
		
	}
   
    private void speakOut(){
    	// TTS processing
    	String text = txtText.getText().toString();
    	tts.speak(text, TextToSpeech.QUEUE_FLUSH, null);
    }

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		
	}
     
	
	
    @Override
    protected boolean isRouteDisplayed(){
    	return false;
    }
    
    
   public void getLastLocation(){
  	String provider = getBestProvider();
   	currentLocation = locationManager.getLastKnownLocation(provider);
   	
   	   currentPoint = new GeoPoint(22396428, 114109497);
   	   currentLocation = new Location("");
   	   currentLocation.setLatitude(currentPoint.getLatitudeE6() / 1e6);
   	   currentLocation.setLongitude(currentPoint.getLongitudeE6()/ 1e6);
   	   
       if (currentLocation != null) {
    	   
        	setCurrentLocation(currentLocation);
       } else {
       	Toast.makeText(this,"Location not yet acquired",Toast.LENGTH_LONG).show();
        	
        }
   }
    
    public void animateToCurrentLocation(){
    	if(currentPoint != null){
    		mapController.animateTo(currentPoint);
    	}
    }
    
    public String getBestProvider(){
    	locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
    	Criteria criteria = new Criteria();
    	criteria.setPowerRequirement(Criteria.NO_REQUIREMENT);
    	criteria.setAccuracy(Criteria.NO_REQUIREMENT);
    	String bestProvider = locationManager.getBestProvider(criteria,true);
    	//Location location = locationManager.getLastKnownLocation(bestProvider);
    	
    	//if(location != null){
    	//	onLocationChanged(location);
    	//}
    	return bestProvider;
    }

     public void setCurrentLocation(Location location){
    	 int currLatitude = (int)(location.getLatitude()*1E6);
    	 int currLongitude = (int)(location.getLongitude()*1E6);
    	 currentPoint = new GeoPoint(currLatitude, currLongitude);
    	 currentLocation = new Location("");
    	 currentLocation.setLatitude(currentPoint.getLatitudeE6() / 1e6);
    	 currentLocation.setLongitude(currentPoint.getLongitudeE6() /1e6);
     
    	 drawCurPositionOverlay();
     }
     
     public void drawCurPositionOverlay(){
  	    List<Overlay> mapOverlays = mapView.getOverlays();
  	    mapOverlays.remove(currPos);
  	    
  	    Drawable drawable = getResources().getDrawable(R.drawable.ic_launcher);
  	    mContext = mapView.getContext();
  	    currPos = new LocationfinderOverlay(drawable, mContext);
  	    
  	    if(currentPoint != null){
  	    	OverlayItem overlayitem = new OverlayItem(currentPoint, "Hi", "Here I am");
  	    	currPos.addOverlay(overlayitem);
  	    	mapOverlays.add(currPos);
  	    	currPos.setCurrentLocation(currentLocation);
  	    }
     }
     
     
     @Override
     public void onProviderDisabled(String arg0){
    	 // auto-generated method stub
    	 Toast.makeText(this,"Provider Dsiabled",Toast.LENGTH_LONG).show();
     }
     
     @Override
     public void onProviderEnabled(String arg0){
    	 Toast.makeText(this,"Provider Enabled",Toast.LENGTH_LONG).show();
     }
     
     @Override
     public void onStatusChanged(String arg0, int arg1, Bundle arg2){
    	 Toast.makeText(this,"Status Changed",Toast.LENGTH_LONG).show();
     }
     
     @Override
     public void onLocationChanged(Location newLocation){
    	 // auto-generated method stub
    	 setCurrentLocation(newLocation);
     }
     
     @Override
     protected void onResume(){
    	 super.onResume();
    	 locationManager.requestLocationUpdates(getBestProvider(), 500,3,this);
     }
     
     @Override
     protected void onPause(){
    	 super.onPause();
    	 locationManager.removeUpdates(this);
     }    
    
}
