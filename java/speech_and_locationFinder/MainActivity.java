package com.example.speechrecandsyn;

import android.app.Activity;
import android.os.Bundle;

import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.view.View;
import android.util.Log;
// editable text-field
import android.widget.EditText;

// TTS facility
import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.speech.RecognizerIntent;

import java.util.Locale;
import java.util.ArrayList;
import java.util.List;


public class MainActivity extends Activity implements OnClickListener, OnInitListener {

    private static final int REQUEST_CODE= 1111;
    private ListView wordsList;
    
	// an instance variable for TTS object
	private TextToSpeech tts;
	
	private Button btnSpeak;
	private EditText txtText;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    
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
     
}
