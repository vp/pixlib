/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.pixlib.prefs.strategy 
{
	import net.pixlib.prefs.PXPreferences;
	import net.pixlib.services.PXHTTPService;
	import net.pixlib.services.PXHTTPServiceHelper;
	import net.pixlib.services.PXServiceEvent;

	/**
	 * The PXHTTPStrategy class implements HTTP communication 
	 * as PXPreferences strategy.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var strategy : PXPreferencesStrategy = new PXHTTPStrategy("load.php", "save.php", URLRequestMethod.POST);
	 * 
	 * var prefs : PXPreferences = PXPreferences.get("main");
	 * prefs.strategy = strategy;
	 * prefs.addEventListener(PXPreferencesEvent.onPreferencesSaveEVENT, onSaveHandler);
	 * prefs.setValue("name", "Pixlib");
	 * prefs.save();
	 * </listing>
	 * 
	 * @see PIXSERVICE_DOC/net/pixlib/services/PXHTTPService.html net.pixlib.services.PXHTTPService
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXHTTPStrategy extends PXAbstractStrategy 
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		private var _helper : PXHTTPServiceHelper; 

		/** @private */
		private var _loadURL : String; 

		/** @private */
		private var _saveURL : String; 

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * HTTP Property name to send / receive preferences data.
		 * 
		 * @default prefName
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static var PREF_NAME : String = "prefName";
		
		/**
		 * HTTP Property name to send preferences data.
		 * 
		 * @default data
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static var PREF_DATA : String = "data";

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	loadURL		URL to call for loading processing
		 * @param	saveURL		URL to call for saving processing				 * @param	method		(optionap) Communication method (PRE or POST)		
		 * @param	dataFormat	(optional) Communication data format		
		 * @param	timeout		(optional) Timout delay
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public function PXHTTPStrategy(loadURL : String, saveURL : String, method : String = "POST", dataFormat : String = "text", timeout : uint = 3000)
		{
			super();
			
			_helper = new PXHTTPServiceHelper(null, method, dataFormat, timeout);
			_loadURL = loadURL;
			_saveURL = saveURL;
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
				
		/**
		 * Loads preferences data using PXHTTPService strategy.
		 * 
		 * @param preferences	PXPreferences owner
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onLoad(preferences : PXPreferences) : void
		{
			var service : PXHTTPService = new PXHTTPService(_loadURL, _helper.method, _helper.dataFormat, _helper.timeout);
			service.addVariable(PREF_NAME, preferences.id);
			service.addEventListener(PXServiceEvent.onDataResultEVENT, onLoadCompleteHandler);
			service.addEventListener(PXServiceEvent.onDataErrorEVENT, onLoadErrorHandler);
			service.execute();
		}

		/**
		 * Triggered when loading process is complete.
		 * 
		 * @param event	PXServiceEvent flow
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onLoadCompleteHandler(event : PXServiceEvent) : void
		{
			if(onLoadCallback is Function) onLoadCallback(event.result);
			
			event.service.release();
		}
		
		/**
		 * Triggered when an error occured during HTTP Loading.
		 * 
		 * @param event	PXServiceEvent event flow
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onLoadErrorHandler(event : PXServiceEvent) : void
		{
			if(onLoadCallback is Function) onLoadCallback(null);
			
			event.service.release();
		}

		/**
		 * Saves preferences data using PXHTTPService strategy.
		 * 
		 * @param preferences	PXPreferences owner
		 * @param data			Raw data to save
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onSave(preferences : PXPreferences, data : Object) : void
		{
			var service : PXHTTPService = new PXHTTPService(_saveURL, _helper.method, _helper.dataFormat, _helper.timeout);
			service.addVariable(PREF_NAME, preferences.id);
			service.addVariable(PREF_DATA, data);
			service.addEventListener(PXServiceEvent.onDataResultEVENT, onSaveCompleteHandler);
			service.addEventListener(PXServiceEvent.onDataErrorEVENT, onSaveErrorHandler);
			service.execute();
		}

		/**
		 * Triggered when saving process is complete.
		 * 
		 * @param event	PXServiceEvent event flow
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onSaveCompleteHandler(event : PXServiceEvent) : void
		{
			if(onSaveCallback is Function) onSaveCallback(true);
			
			event.service.release();
		}

		/**
		 * Triggered when an error occured during saving process.
		 * 
		 * @param event	PXServiceEvent event flow
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onSaveErrorHandler(event : PXServiceEvent) : void
		{
			if(onSaveCallback is Function) onSaveCallback(false);
			
			event.service.release();
		}
	}
}
