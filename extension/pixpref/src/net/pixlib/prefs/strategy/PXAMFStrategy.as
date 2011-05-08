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
	import net.pixlib.services.PXAMFService;
	import net.pixlib.services.PXAMFServiceHelper;
	import net.pixlib.services.PXServiceEvent;

	/**
	 * The PXAMFStrategy class implements AMF communication 
	 * as Preferences strategy.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var strategy : PXPreferencesStrategy = new PXAMFStrategy("gateway.php", "loadService", "saveService");
	 * 
	 * var prefs : PXPreferences = PXPreferences.get("main");
	 * prefs.strategy = strategy;
	 * prefs.addEventListener(PXPreferencesEvent.onPreferencesSaveEVENT, onSaveHandler);
	 * prefs.setValue("name", "Pixlib");
	 * prefs.save();
	 * </listing>
	 * 
	 * @see PIXSERVICE_DOC/net/pixlib/services/PXAMFService.html net.pixlib.services.PXAMFService
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXAMFStrategy extends PXAbstractStrategy 
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		private var _helper : PXAMFServiceHelper;

		/** @private */ 		private var _loadMethod : String;

		/** @private */		private var _saveMethod : String; 

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	gateway			AMF gateway url
		 * @param	loadMethod		AMF method to call for loading process				 * @param	saveMethod		AMF method to call	for saving process	
		 * @param	timeout			(optional) AMF call timout
		 * @param	encoding		(optional) AMF encoding property
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public function PXAMFStrategy(gateway : String, service : String, loadMethod : String, saveMethod : String, timeout : uint = 3000, encoding : uint = 3)
		{
			super();
			
			_helper = new PXAMFServiceHelper(gateway, service, null, timeout, encoding);			_loadMethod = loadMethod;
			_saveMethod = saveMethod;
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
				
		/**
		 * Loads preferences data using PXAMFService strategy.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onLoad(preferences : PXPreferences) : void
		{
			var service : PXAMFService = new PXAMFService(_helper.gateway, _helper.service, _loadMethod, _helper.timeout, _helper.encoding);
			service.setArguments(preferences.id);
			service.addEventListener(PXServiceEvent.onDataResultEVENT, onLoadCompleteHandler);			service.addEventListener(PXServiceEvent.onDataErrorEVENT, onLoadErrorHandler);
			service.execute();
		}

		/**
		 * Triggered when data are loaded from AMF call.
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
		 * Triggered when an error occured during AMF call.
		 * 
		 * @param event	PXServiceEvent flow
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
		 * Saves preferences data using PXAMFService strategy.
		 * 
		 * @param	preferences	PXPreferences owner
		 * @param	data		Raw data to save
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onSave(preferences : PXPreferences, data : Object) : void
		{
			var service : PXAMFService = new PXAMFService(_helper.gateway, _helper.service, _saveMethod, _helper.timeout, _helper.encoding);
			service.setArguments(preferences.id, data);
			service.addEventListener(PXServiceEvent.onDataResultEVENT, onSaveCompleteHandler);
			service.addEventListener(PXServiceEvent.onDataErrorEVENT, onSaveErrorHandler);
			service.execute();
		}

		/**
		 * Triggered when data are saved throw AMF call.
		 * 
		 * @param event	PXServiceEvent flow
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
		 * Triggered when an error occured during AMF call.
		 * 
		 * @param event	PXServiceEvent flow
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
