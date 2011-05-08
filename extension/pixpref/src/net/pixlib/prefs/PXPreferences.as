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
package net.pixlib.prefs 
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.encoding.PXDeserializer;
	import net.pixlib.encoding.PXSerializer;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.prefs.event.PXPreferencesEvent;
	import net.pixlib.prefs.event.PXPreferencesListener;
	import net.pixlib.prefs.strategy.PXPreferencesStrategy;
	import net.pixlib.utils.PXClassUtils;

	import flash.events.Event;

	/**
	 * Dispatched when a preference value is edited (or created).
	 *  
	 * @eventType net.pixlib.prefs.event.PXPreferencesEvent.onPreferenceEditEVENT
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onPreferenceEdit", type="net.pixlib.prefs.event.PXPreferencesEvent")]

	/**
	 * Dispatched when a preference is deleted.
	 *  
	 * @eventType net.pixlib.prefs.event.PXPreferencesEvent.onPreferenceDeleteEVENT
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onPreferenceDelete", type="net.pixlib.prefs.event.PXPreferencesEvent")]

	/**
	 * Dispatched when preferences are loaded.
	 *  
	 * @eventType net.pixlib.prefs.event.PXPreferencesEvent.onPreferencesLoadEVENT
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onPreferencesLoad", type="net.pixlib.prefs.event.PXPreferencesEvent")]

	/**
	 * Dispatched when preferences are saved.
	 *  
	 * @eventType net.pixlib.prefs.event.PXPreferencesEvent.onPreferencesSaveEVENT
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onPreferencesSave", type="net.pixlib.prefs.event.PXPreferencesEvent")]

	/**
	 * The PXPreference class allow to load/save application preferences (configuration, 
	 * user customization, etc) using different strategy.
	 * 
	 * <p>Available strategies are 
	 * <ul>
	 * 	<li>PXAMFStrategy : AMF communication</li>	 * 	<li>PXHTTPStrategy : HTTP communication</li>	 * 	<li>PXSOStrategy : SharedObject</li>
	 * 	<li>PXFileStrategy : File system</li>
	 * </ul></p>
	 * 
	 * @example AMF strategy to manage main application preferences
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
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXPreferences 
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		private static const _M : PXHashMap = new PXHashMap();

		/** @private */
		private var _name : String; 

		/** @private */
		private var _broadcaster : PXEventBroadcaster; 

		/** @private */
		private var _changed : Boolean;

		/** @private */
		private var _saved : Boolean; 

		/** @private */
		private var _strategy : PXPreferencesStrategy; 

		/** @private */
		private var _pendingCall : Boolean; 

		/** @private */
		private var _deserializer : PXDeserializer; 

		/** @private */
		private var _serializer : PXSerializer; 

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**
		 * Stores preference values.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oData : Object;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Preferences identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get id() : String
		{
			return _name;		
		}
		
		/**
		 * Indicates deserializer process to use to deserialize data when 
		 * data are loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function set deserializer(deserializer : PXDeserializer) : void
		{
			_deserializer = deserializer;
		}

		/**
		 * @private
		 */
		public function get deserializer( ) : PXDeserializer
		{
			return _deserializer;
		}

		/**
		 * Indicates serializer process to use to serialize data before saving 
		 * process.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function set serializer(serializer : PXSerializer) : void
		{
			_serializer = serializer;
		}

		/**
		 * @private
		 */
		public function get serializer( ) : PXSerializer
		{
			return _serializer;
		}

		/**
		 * Indicates strategy to use for load/save preferences process.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get strategy() : PXPreferencesStrategy
		{
			return _strategy;
		}

		/**
		 * @private
		 */
		public function set strategy(strategy : PXPreferencesStrategy) : void
		{
			if(!running)
			{
				if(_strategy) 
				{
					_strategy.release();
					_strategy = null;
				}
				
				_strategy = strategy;
				_strategy.onLoadHandler = onDataLoadedHandler;
				_strategy.onSaveHandler = onDataSavedHandler;
			}
			else
			{
				PXDebug.ERROR("setStrategy() failed. Strategy is currently running.", this);
			}
		}
		
		/**
		 * Preferences data object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get data() : Object
		{
			return oData;
		}
		
		/**
		 * @private
		 */
		public function set data(value : Object) : void
		{
			oData = value;
			
			fireEvent(new PXPreferencesEvent(PXPreferencesEvent.onPreferenceEditEVENT, this));
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns a unique <code>PXPreferences</code> instance for 
		 * passed-in <code>name</code> identifier.
		 * 
		 * @return PXPreferences instance for passed-in identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function get(id : String = null) : PXPreferences
		{
			if(id == null) id = PXClassUtils.getClassName(PXPreferences);
			
			if (!(PXPreferences._M.containsKey(id))) 
				PXPreferences._M.put(id, new PXPreferences(id));
			
			return PXPreferences._M.get(id);
		}

		/**
		 * Saves property name/value in preferences.
		 * 
		 * @param name	Property name
		 * @param value	Poperty value
		 * 
		 * @return 	<code>true</code> if processing is correct; <code>false</code> 
		 * 			if an IO task is already running.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setValue(name : String, value : *) : Boolean
		{
			if(!running)
			{
				var currentValue : * = getValue(name);
				setChanged(currentValue != value);
				
				if(hasChanged())
				{
					oData[name] = value;
					
					fireEvent(new PXPreferencesEvent(PXPreferencesEvent.onPreferenceEditEVENT, this, name, currentValue, value));
				}
				
				return true;
			}
			else
			{
				PXDebug.ERROR("setValue() failed. An I/O call is running.", this);
			}
			
			return false;
		}

		/**
		 * Returns property value registered with passed-in variable name.
		 * 
		 * @param name			Variable name
		 * @param defaultValue	(optional) Value to return if not found in
		 * 						preferences data
		 * 						
		 * @return preference value registered with passed-in variable name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getValue(name : String, defaultValue : * = null) : *
		{
			if(oData[name] != undefined)
			{
				return oData[name];
			}
			
			return defaultValue;
		}

		/**
		 * Deletes property registered with passed-in name from preferences.
		 * 
		 * @param name	Property name
		 * 
		 * @return 	<code>true</code> if processing is correct; <code>false</code> 
		 * 			if an IO task is already running.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function deleteValue(name : String) : Boolean
		{
			if(!running)
			{
				if( oData[name] != undefined )
				{
					var oldValue : * = getValue(name);
					
					delete oData[name];
					
					setChanged(true);
					
					fireEvent(new PXPreferencesEvent(PXPreferencesEvent.onPreferenceDeleteEVENT, this, name, oldValue));
					
					return true; 
				}
				else
				{
					PXDebug.WARN("deleteValue() failed. variable '"+ name +"' not exist.", this);
				}
			}
			else
			{
				PXDebug.ERROR("deleteValue() failed. An I/O call is running.", this);
			}
			
			return false;
		}

		/**
		 * Returns <code>true</code> if preferences has changed
		 * (creation, edition or deletion).
		 * 
		 * @return	<code>true</code> if preferences has changed
		 * 			(creation, edition or deletion).
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function hasChanged() : Boolean
		{
			return _changed;
		}

		/**
		 * Returns <code>true</code> if current preferences data are saved.
		 * 
		 * @return <code>true</code> if current preferences data are saved.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isSaved() : Boolean
		{
			return (_saved && !_changed);
		}

		/**
		 * Returns <code>true</code> if an load/save task is currently 
		 * running.
		 * 
		 * @return <code>true</code> if an load/save task is currently 
		 * running.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get running() : Boolean
		{
			return _pendingCall;
		}

		/**
		 * Loads preferences.
		 * 
		 * @throws	net.pixlib.exception.PXIllegalArgument If PXPreferences strategy 
		 * 			is not defined.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function load() : void
		{
			if(_strategy != null )
			{
				if(!running)
				{
					_pendingCall = true;
					_strategy.load(this);
				}
				else
				{
					PXDebug.ERROR("load() failed. An I/O call is already running.", this);
				}
			}
			else
			{
				throw new PXIllegalArgumentException("Preference strategy is null", this);
			}
		}

		/**
		 * Saves preferences.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function save() : void
		{
			if(_strategy != null )
			{
				if(!running)
				{
					_pendingCall = true;
					
					_strategy.save(this, _serializer ? _serializer.serialize(oData) : oData);
				}
				else
				{
					PXDebug.ERROR("save() failed. An I/O call is already running.", this);
				}
			}
			else
			{
				throw new PXIllegalArgumentException("Preference strategy is null", this);
			}
		}

		/**
		 * Adds the passed-in listener as listener for all events dispatched
		 * by this event broadcaster. The function returns <code>true</code>
		 * if the listener has been added at the end of the call. If the
		 * listener is already registered in this event broadcaster the function
		 * returns <code>false</code>.
		 * <p>
		 * Note : the listener could be either an object or a function.
		 * </p>
		 * 
		 * @param	listener	the listener object to add as global listener
		 * 
		 * @return	<code>true</code> if the listener have been added during this call
		 * 
		 * @throws 	net.pixlib.exception.PXIllegalArgumentException If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster and is not a Function.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addListener( listener : PXPreferencesListener ) : Boolean
		{
			return _broadcaster.addListener(listener);
		}

		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object
		 * 						
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeListener( listener : PXPreferencesListener ) : Boolean
		{
			return _broadcaster.removeListener(listener);
		}

		/**
		 * Adds an event listener for the specified event type.
		 * There is two behaviors for the <code>addEventListener</code>
		 * function : 
		 * <ol>
		 * <li>The passed-in listener is an object : 
		 * The object is added as listener only for the specified event, the object must
		 * have a function with the same name than <code>type</code> or at least a
		 * <code>handleEvent</code> function.</li>
		 * <li>The passed-in listener is a function : 
		 * There is no restriction concerning the name of the function. If the <code>rest</code> 
		 * is not empty, all elements in it will be used as additional arguments when 
		 * event callback will happen. </li>
		 * </ol>
		 * 
		 * @param	type		name of the event for which register the listener
		 * @param	listener	object or function which will receive this event
		 * @param	rest		additional arguments for the function listener
		 * 
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event
		 * 			
		 * @throws 	net.pixlib.exception.PXUnsupportedOperationException If the listener 
		 * 			is an object which have neither a function with the same name than 
		 * 			the event type nor a function called <code>handleEvent</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addEventListener( type : String, listener : Object, ...rest ) : Boolean
		{
			return _broadcaster.addEventListener.apply(_broadcaster, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}

		/**
		 * Removes the passed-in listener for listening the specified event. The
		 * listener could be either an object or a function.
		 * 
		 * @param	type		name of the event for which unregister the listener
		 * @param	listener	object or function to be unregistered
		 * 
		 * @return	<code>true</code> if the listener has been successfully removed
		 * 			as listener for the passed-in event
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _broadcaster.removeEventListener(type, listener);
		}

		/**
		 * Removes all listeners registered in this event broadcaster.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAllListeners() : void
		{
			_broadcaster.removeAllListeners();
		}

		/**
		 * Returns string reprsenation of instance.
		 * 
		 * @return string representation of instance.
		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Indicates if preferences has changed.
		 * 
		 * @param value	Boolean state
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function setChanged(value : Boolean) : void
		{
			_changed = value;
		}		

		/**
		 * Triggered when strategy has loaded preferences.
		 * 
		 * @param event	Event instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onDataLoadedHandler(data : Object = null) : void
		{
			if(data != null)
			{
				oData = _deserializer ? _deserializer.deserialize(data) : data;
			}
			else oData = {};
			
			setChanged(false);
			
			_pendingCall = false;
			
			fireOnLoadEvent();
		}

		/**
		 * Triggered when strategy has saved preferences.
		 * 
		 * @param event	Boolean event state
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onDataSavedHandler(success : Boolean) : void
		{
			_saved = success;
			
			if(_saved) setChanged(false);
			
			_pendingCall = false;
			
			fireOnSaveEvent();
		}

		/**
		 * Broadcasts passed-in event.
		 * 
		 * @param event	Event to dispatch
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function fireEvent(event : Event) : void
		{
			event.stopImmediatePropagation();
			
			_broadcaster.broadcastEvent(event);
		}	

		/**
		 * Broadcasts <code>(PXPreferencesEvent.onPreferencesLoadEVENT</code> event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function fireOnLoadEvent() : void
		{
			_broadcaster.broadcastEvent(new PXPreferencesEvent(PXPreferencesEvent.onPreferencesLoadEVENT, this));
		}

		/**
		 * Broadcasts <code>(PXPreferencesEvent.onPreferencesSaveEVENT</code> event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function fireOnSaveEvent() : void
		{
			_broadcaster.broadcastEvent(new PXPreferencesEvent(PXPreferencesEvent.onPreferencesSaveEVENT, this));
		}

		
		//--------------------------------------------------------------------
		// Private methods
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		function PXPreferences(name : String)
		{
			_name = name;
			_changed = false;
			_saved = true;
			_pendingCall = false;
			_broadcaster = new PXEventBroadcaster(this);
			
			oData = {};
		}		
	}
}