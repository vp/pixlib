/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */
package net.pixlib.tms{	import net.pixlib.collections.PXHashMap;	import net.pixlib.commands.PXSequencer;	import net.pixlib.events.PXBasicEvent;	import net.pixlib.events.PXEventBroadcaster;	import net.pixlib.exceptions.PXUnsupportedOperationException;	import net.pixlib.log.PXDebug;	import net.pixlib.log.PXStringifier;	import net.pixlib.services.PXAMFService;	import net.pixlib.services.PXHTTPService;	import net.pixlib.services.PXStreamService;	import net.pixlib.tms.bundles.PXILanguageBundle;	import net.pixlib.tms.bundles.PXLanguageBundle;	import net.pixlib.tms.bundles.PXLoadableBundle;	import net.pixlib.tms.bundles.PXMOLanguageBundle;	import net.pixlib.tms.bundles.PXPOLanguageBundle;	import net.pixlib.tms.bundles.PXPropLanguageBundle;	import net.pixlib.tms.bundles.PXXLIFFLanguageBundle;	import net.pixlib.tms.bundles.PXXMLLanguageBundle;	import net.pixlib.utils.PXStringUtils;	import flash.events.Event;			/**	 * The PXLanguage class manages application localization.	 * 	 * @see Unicode Technical Standard #35 http://unicode.org/reports/tr35/	 * 	 * @author Romain Ecarnot	 * 	 * @langversion 3.0	 * @playerversion Flash 10	 */
	final public class PXLanguage
	{		// --------------------------------------------------------------------		// Event type		// --------------------------------------------------------------------				/**		 * Defines the value of the <code>type</code> property of the event 		 * object for a <code>onChange</code> event.		 * 		 * <p>The properties of the event object have the following values:</p>		 * <table class="innertable">		 *     <tr><th>Property</th><th>Value</th></tr>		 *     <tr>		 *     	<td><code>type</code></td>		 *     	<td>Dispatched event type</td>		 *     </tr>		 *     <tr>		 *     	<td><code>target</code></td>		 *     	<td>Language instance</td>		 *     </tr>		 * </table>		 * 		 * @eventType onChange		 */	
		public static const onChangeEVENT : String = "onChange";		
				// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------				/**		 * @private		 */
		private static  var _instance : PXLanguage ;
				/**		 * @private		 */
		private var _language : String;
		
		/**		 * @private		 */
		private var _bundleMap : PXHashMap;
		
		/**		 * @private		 */
		private var _broadcaster : PXEventBroadcaster;
		
		/**		 * @private		 */
		private var _loader : PXSequencer;				
		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------		
		/**		 * Current application language.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function get current() : String
		{
			return _language;
		}
		
		/** @private */
		public function set current(value : String) : void
		{
			if (value != _language)
			{
				if ( !_bundleMap.containsKey(value)) _bundleMap.put(value, new Vector.<PXILanguageBundle>());
								var bundleList : Vector.<PXILanguageBundle> = _bundleMap.get(value);
								if ( _loader.length > 0 ) _loader.clear();								var loadable : PXLoadableBundle;
				for each (var bundle : PXILanguageBundle in bundleList)
				{
					if ( bundle is PXLoadableBundle )
					{
						loadable = bundle as PXLoadableBundle;
						if (!loadable.loaded)
						{
							_loader.addCommand(bundle as PXLoadableBundle);
						}
					}
				}				
				if ( _loader.length > 0 )
				{
					_loader.addEventListener(PXSequencer.onSequencerEndEVENT, _onSequenceEnd, value);
					_loader.execute();
				}
				else
				{
					_language = value;
					_broadcaster.broadcastEvent(new PXBasicEvent(PXLanguage.onChangeEVENT, this));
				}
			}
		}				/**		 * Returns available registered languages.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		public function get availableLanguages() : Array		{			return _bundleMap.keys;		}		
		// --------------------------------------------------------------------		// Public API		// --------------------------------------------------------------------		
		/**		 * Returns singleton instance of PXLanguage class.		 * 		 * @return The singleton instance of PXLanguage class.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static function getInstance() : PXLanguage
		{
			if (!(_instance is PXLanguage)) _instance = new PXLanguage();
			return _instance;
		}
		
		/**		 * Releases singleton instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static function release() : void
		{
			if (_instance is PXLanguage) 			{				_instance.clear();				_instance = null;
			}		}

		/**		 * Adds new bundle to localization system.		 * 		 * @param bundle PXILanguageBundle  bundle to add		 * 		 * @return <code>true</code> if bundle is well registered.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function addBundle(bundle : PXILanguageBundle) : Boolean
		{
			if ( !_bundleMap.containsKey(bundle.language)) _bundleMap.put(bundle.language, new Vector.<PXILanguageBundle>());
			try
			{
				if ( !isBundleRegistered(bundle.language, bundle.id))
				{
					_bundleMap.get(bundle.language).push(bundle);
					return true;
				}
				else
				{
					PXDebug.ERROR("A bundle named '" + bundle.id + "' is already registered for '" + bundle.language + "'.", this);
					return false;
				}
			}
			catch(e : Error)
			{
				throw new PXUnsupportedOperationException("LocalBundle can't be registered : " + e.message, this);
			}
			return false;
		}
		
		/**		 * Returns <code>true</code> if a resource is contained in possible 		 * bundle.		 * 		 * @param key		Resource's identifier		 * @param bundleID	(optional) Bundle's identifier		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function hasResource(key : String, bundleID : String = PXLanguageBundle.ID) : Boolean
		{
			if (bundleID == null) bundleID = PXLanguageBundle.ID;			
			if ( isBundleRegistered(_language, bundleID))
			{
				var bundle : PXILanguageBundle = getBundle(_language, bundleID);
				if ( bundle.hasResource(key))
				{
					return true;
				}
				else PXDebug.ERROR("Resource named '" + key + "' is not registered in '" + bundleID + "' for '" + _language + "'.", this);
			}
			else PXDebug.ERROR("LocalBundle named '" + bundleID + "' is not registered in '" + _language + "'.", this);
			return false;
		}

		/**		 * Returns <code>true</code> if bundles are registered for passed-in 		 * search language.		 * 		 * @param search Language to search		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function hasLanguage(search : String) : Boolean
		{
			return _bundleMap.containsKey(search);
		}
		
		/**		 * Returns language resource registered by passed-in key identifier 		 * in bundleID PXILanguageBundle for current language.		 * 		 * @param key			Resource to find		 * @param bundleID		LanguageBundle to use		 * @param defaultValue	Default value if resource is null		 * 		 * @return language resource registered by passed-in key identifier 		 * in bundleID PXILanguageBundle for current language.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function getResource(key : String, bundleID : String = PXLanguageBundle.ID, defaultValue : * = "") : String
		{			if (bundleID == null) bundleID = PXLanguageBundle.ID;			
			var bundle : PXILanguageBundle = getBundle(_language, bundleID);
			if (bundle && bundle.hasResource(key))
			{
				return bundle.getResource(key);
			}
			else return defaultValue;
		}
		
		/**		 * Returns language resource registered by passed-in key identifier 		 * in bundleID PXILanguageBundle for current language.		 * 		 * @param key			Resource to find		 * @param bundleID		LanguageBundle to use		 * @param defaultValue	Default value if resource is null		 * @param substitutions properties			 * 		 * @return language resource registered by passed-in key identifier 		 * in bundleID PXILanguageBundle for current language.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function getString(key : String, bundleID : String = PXLanguageBundle.ID, defaultValue : String = "", substitutions : Array = null) : String
		{			if (bundleID == null) bundleID = PXLanguageBundle.ID;			
			var value : String = getResource(key, bundleID, defaultValue);						if(value && substitutions)			{
				value = PXStringUtils.substitute.apply(null, [value].concat(substitutions));			}			
			return value;
		}
		
		/**		 * Returns language resource registered by passed-in key identifier 		 * in bundleID PXILanguageBundle for current language.		 * 		 * <p>Result is cast to Number.</p>		 * 		 * @param key			Resource to find		 * @param bundleID		LanguageBundle to use		 * @param defaultValue	Default value if resource is null		 * 		 * @return language resource registered by passed-in key identifier 		 * in bundleID PXILanguageBundle for current language.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function getNumber(key : String, bundleID : String = PXLanguageBundle.ID, defaultValue : Number = 0) : Number
		{			if (bundleID == null) bundleID = PXLanguageBundle.ID;			
			var value : String = getResource(key, bundleID, defaultValue);
			return Number(value) || defaultValue;
		}
		
		/**		 * Adds an event listener for the specified event type.		 * There is two behaviors for the <code>addEventListener</code>		 * function : 		 * <ol>		 * <li>The passed-in listener is an object : 		 * The object is added as listener only for the specified event, the object must		 * have a function with the same name than <code>type</code> or at least a		 * <code>handleEvent</code> function.</li>		 * <li>The passed-in listener is a function : 		 * There is no restriction concerning the name of the function. If the <code>rest</code> 		 * is not empty, all elements in it will be used as additional arguments when 		 * event callback will happen. </li>		 * </ol>		 * 		 * @param	type		name of the event for which register the listener		 * @param	listener	object or function which will receive this event		 * @param	rest		additional arguments for the function listener		 * 		 * @return	<code>true</code> if the function have been succesfully added as		 * 			listener fot the passed-in event		 * 					 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If the listener is an object		 * 			which have neither a function with the same name than the event type nor		 * 			a function called <code>handleEvent</code>		 * 					 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function addEventListener(type : String, listener : Object, ... rest) : Boolean
		{
			return _broadcaster.addEventListener.apply(_broadcaster, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}

		/**		 * Removes the passed-in listener for listening the specified event. The		 * listener could be either an object or a function.		 * 		 * @param	type		name of the event for which unregister the listener		 * @param	listener	object or function to be unregistered		 * 		 * @return	<code>true</code> if the listener has been successfully removed		 * 			as listener for the passed-in event		 * 					 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function removeEventListener(type : String, listener : Object) : Boolean
		{
			return _broadcaster.removeEventListener(type, listener);
		}

		/**		 * Clears all PXILanguageBundle and release the PXEventBroadcaster.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function clear() : void
		{
			_broadcaster.removeAllListeners();
			_bundleMap.clear();
		}
				/**		 * Parses xml data to retreive and create PXILanguageBundle		 * 		 * <p>Defines XLIFF localization using default PXHTTPService as 		 * localization loader.		 * <listing>		 * 	&lt;localization type=&quot;XLIFF&quot;&gt;		 * 	&lt;language code=&quot;en_US&quot;&gt;		 * 		&lt;bundle name=&quot;&quot; url=&quot;en_US.xml&quot;/&gt;&lt;!-- default name --&gt;		 * 		&lt;bundle name=&quot;custom&quot; url=&quot;en_US_custom.xml&quot;/&gt;		 * 	&lt;/language&gt;		 * <br />		 * 	&lt;language code=&quot;fr_FR&quot;&gt;		 * 		&lt;bundle name=&quot;&quot; url=&quot;fr_FR.xml&quot;/&gt;&lt;!-- default name --&gt;		 * 		&lt;bundle name=&quot;custom&quot; url=&quot;fr_FR_custom.xml&quot;/&gt;		 * 	&lt;/language&gt;		 * &lt;/localization&gt;		 * </listing>		 * </p>		 * 		 * <p>Defines XML localization using PXAMFService as localization loader.		 * <listing>		 * 	&lt;localization type=&quot;XML&quot;&gt;		 * 	&lt;language code=&quot;en_US&quot;&gt;		 * 		&lt;bundle name=&quot;&quot; url=&quot;en_US.xml&quot; service=&quot;Localization.get&quot;/&gt;		 * 	&lt;/language&gt;		 * <br />		 * 	&lt;language code=&quot;fr_FR&quot;&gt;		 * 		&lt;bundle name=&quot;&quot; url=&quot;fr_FR.xml&quot; service=&quot;Localization.get&quot;/&gt;		 * 	&lt;/language&gt;		 * &lt;/localization&gt;		 * </listing>		 * </p>		 * 		 * @param xml Localization definition.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */		public function parseXML(xml : XML) : void		{			var type : String = xml.@type.toString();			var code : String;			var bundle : PXLanguageBundle;			var bundleID : String;			var service : String;						for each (var langNode : XML in xml.language) 			{
				code = langNode.@code.toString();								for each (var bundleNode : XML in langNode.bundle) 				{
					bundleID = bundleNode.@name.toString();
					if (!bundleID || bundleID.length == 0) bundleID = PXLanguageBundle.ID;										switch(type)					{						case "XML" : 							bundle = new PXXMLLanguageBundle(code, null, bundleID);							break;						case "XLIFF" :							bundle = new PXXLIFFLanguageBundle(code, null, bundleID); 							break;						case "PROP" :							bundle = new PXPropLanguageBundle(code, null, bundleID); 							break;						case "PO" :							bundle = new PXPOLanguageBundle(code, null, bundleID); 							break;						case "MO" :							bundle = new PXMOLanguageBundle(code, null, bundleID); 							break;					}
										service = bundleNode.@service.toString();										if(type == "MO")					{						addBundle(new PXLoadableBundle(bundle, new PXStreamService(bundleNode.@url.toString())));					}					else if(service.length > 0)					{								var params : Array = service.split(".");						addBundle(new PXLoadableBundle(bundle, new PXAMFService(bundleNode.@url.toString(), params[0], params[1])));					}					else					{						addBundle(new PXLoadableBundle(bundle, new PXHTTPService(bundleNode.@url.toString())));						}				}			}		}				/**		 * Returns string representation of instance.		 * 		 * @return The string representation of instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------		
		/**		 * Returns PXILanguageBundle registered with passed-in bundleID identifier 		 * for passed-in language target.		 * 		 * @param langTarget	Language to target		 * @param bundleID		LanguageBundle identifier		 * 		 * @return PXILanguageBundle registered with passed-in bundleID identifier 		 * for passed-in language target.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		protected function getBundle(langTarget : String, bundleID : String) : PXILanguageBundle
		{
			if ( _bundleMap.containsKey(langTarget))
			{
				var bundleList : Vector.<PXILanguageBundle> = _bundleMap.get(langTarget);
				for each (var bundle : PXILanguageBundle in bundleList) if ( bundle.id == bundleID ) return bundle;
			}
			else
			{
				PXDebug.ERROR("Local '" + langTarget + "' is not declared in LocalManager.", this);
			}
			return null;
		}

		/**		 * Returns <code>true</code> if PXILanguageBundle is registered with 		 * passed-in bundleID identifier for passed-in language target.		 * 		 * @param langTarget	Language to target		 * @param bundleID		LanguageBundle identifier		 * 		 * @return <code>true</code> if PXILanguageBundle is registered with 		 * passed-in bundleID identifier for passed-in language target.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		protected function isBundleRegistered(langTarget : String, bundleID : String) : Boolean
		{
			return getBundle(langTarget, bundleID) != null;
		}		

		// --------------------------------------------------------------------
		// Private implementation
		// --------------------------------------------------------------------
				/**		 * @private		 */
		function PXLanguage()
		{
			_broadcaster = new PXEventBroadcaster(this);
			_bundleMap = new PXHashMap();
			_loader = new PXSequencer();
		}
				/**		 * @private		 */
		private function _onSequenceEnd(event : Event, value : String) : void
		{
			_language = value;			
			_loader.removeEventListener(PXSequencer.onSequencerEndEVENT, _onSequenceEnd);			
			_broadcaster.broadcastEvent(new PXBasicEvent(PXLanguage.onChangeEVENT, this));
		}
	}
}