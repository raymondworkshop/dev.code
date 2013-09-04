/**
 * 
 */
package com.example.budgetrecord;

import com.example.budgetrecord.db.MyDbHelper;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Resources;
import android.database.Cursor;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;

/**
 * @author ZHAOWENLONG
 * 
 */
public class SplashScreenActivity extends Activity {

	public static MyDbHelper db = null;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//setContentView(R.layout.splash_screen_activity);
		initialDBData();
		CommonData.getInstance().load(this);
	}
	@Override
	public boolean onTouchEvent(MotionEvent event) {
		// TODO Auto-generated method stub
		//activity jump
		Intent i=new Intent(SplashScreenActivity.this,MainActivity.class);
		startActivity(i);
		this.finish();
		return super.onTouchEvent(event);
	}
	
	private void initialDBData() {
		// 
//		deleteDatabase("mydb");
		db = MyDbHelper.getInstance(this.getApplicationContext());
		Resources res = this.getResources();
		db.open();
		Cursor cursor = db.select("TBL_EXPENDITURE_CATEGORY", new String[] {
				"ID", "NAME", "BUDGET" }, null, null, null, null, null);
		if (cursor.moveToNext()) {
			cursor.close();
//			db.close();
			return;
		}
		//
		String[] arr = res.getStringArray(R.array.TBL_EXPENDITURE_CATEGORY);
		for (int i = 0; i < arr.length; i++) {
			Log.i("TEST", arr[i]);
			db.insert("TBL_EXPENDITURE_CATEGORY", new String[] { "NAME",
					"BUDGET" }, new String[] { arr[i], "0" });

		}
		// 
		arr = res.getStringArray(R.array.TBL_EXPENDITURE_SUB_CATEGORY_1);
		for (int i = 0; i < arr.length; i++) {
			Log.i("TEST", arr[i]);
			db.insert("TBL_EXPENDITURE_SUB_CATEGORY", new String[] { "NAME",
					"PARENT_CATEGORY_ID" }, new String[] { arr[i], "1" });

		}

		//
		arr = res.getStringArray(R.array.TBL_ACCOUNT_TYPE);
		for (int i = 0; i < arr.length; i++) {
			Log.i("TEST", arr[i]);
			db.insert("TBL_ACCOUNT_TYPE", new String[] { "NAME", "POSTIVE" },
					new String[] { arr[i].substring(0, arr[i].indexOf(",")),
							arr[i].substring(arr[i].indexOf(",") + 1) });

		}
		// 
		arr = res.getStringArray(R.array.TBL_ACCOUNT_SUB_TYPE_1);
		for (int i = 0; i < arr.length; i++) {
			Log.i("TEST", arr[i]);
			db.insert("TBL_ACCOUNT_SUB_TYPE", new String[] { "NAME",
					"PARENT_TYPE_ID" }, new String[] { arr[i], "1" });

		}

		//
		arr = res.getStringArray(R.array.TBL_ACCOUNT);
		for (int i = 0; i < arr.length; i++) {
			Log.i("TEST", arr[i]);
			db.insert("TBL_ACCOUNT", new String[] { "NAME", "TYPE_ID",
					"SUB_TYPE_ID", "ACCOUNT_BALANCE" }, arr[i].split(","));
		}

		/*
		 * cursor =db.select("TBL_EXPENDITURE_CATEGORY", new
		 * String[]{"ID","NAME","BUDGET"}, null, null, null, null, null);
		 * while(cursor.moveToNext()) {
		 * Log.i("TBL_EXPENDITURE_CATEGORY",cursor.getString
		 * (0)+","+cursor.getString(1)); }
		 */
//		db.close();

	}
}
