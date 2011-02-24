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
package net.pixlib.core 
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.collections.PXTypedContainer;
	import net.pixlib.events.PXBroadcaster;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.exceptions.PXUnsupportedOperationException;
	import net.pixlib.log.PXLog;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;

	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * Dispatched when an object is registered into locator.
	 *  
	 * @eventType net.pixlib.core.PXLocatorEvent.onRegisterObjectEVENT
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onRegisterObject", type="net.pixlib.core.PXLocatorEvent")]

	/**
	 * Dispatched when an object is unregistered form locator.
	 *  
	 * @eventType net.pixlib.core.PXLocatorEvent.onUnregisterObjectEVENT
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onUnregisterObject", type="net.pixlib.core.PXLocatorEvent")]

	/**
	 * The PXAbstractLocator class defines abstract implementation for 
	 * locator classes.
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXAbstractLocator implements PXLocator, PXTypedContainer
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 * Event broadcaster
		 */
		private var _oEB : PXBroadcaster;
		
		/**
		 * @private
		 * Class if locator is typed
		 */
		private var _cType : Class;
		
		/**
		 * @private
		 * Log instance
		 */
		private var _logger : PXLog;

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**
		 * Map storing <code>String</code> keys associated with
		 * <code>Object</code> values.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var mMap : PXHashMap;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Returns the exclusive PXLog object owned by this locator.
		 * It allow this PXLog to send logging message directly on
		 * its owner logging channel.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get logger() : PXLog
		{
			return _logger;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get type() : Class
		{
			return _cType;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get typed() : Boolean
		{
			return _cType != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get keys() : Array
		{
			return mMap.keys;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get values() : Array
		{
			return mMap.values;
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new locator instance. If the <code>type</code>
		 * argument is defined, the locator is considered as typed, and
		 * then the type of all elements inserted in this locator is checked.
		 * 
		 * @param	type 			<code>Class</code> type for locator elements.
		 * @param	typeListener 	<code>Class</code> type for locator listeners.
		 * @param	log 			PXLog to output locator messages.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXAbstractLocator(type : Class = null, typeListener : Class = null, log : PXLog = null) 
		{
			_cType = ( type != null ) ? type : Object;
			mMap = new PXHashMap();
			_oEB = new PXEventBroadcaster(this, ( typeListener == null ) ? PXLocatorListener : typeListener);
			_logger = (log == null ) ? PXDebug.getInstance() : log;
		}

		/**
		 * @inheritDoc
		 */
		public function isRegistered( name : String ) : Boolean
		{
			return mMap.containsKey(name);
		}

		/**
		 * Registers passed-in object with identifier name to this locator.
		 * 
		 * @param	name	Key identifier
		 * @param	o		Object to store
		 * 
		 * @return 	<code>true</code> if success
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException — Key or object 
		 * 			are already defined in this locator.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function register(name : String, element : Object) : Boolean
		{
			if(typed && !(element is type))
			{
				throw new PXIllegalArgumentException("register() failed. Item must be '" + type.toString() + "' typed.", this);
			}

			if(mMap.containsKey(name))
			{
				throw new PXIllegalArgumentException("item is already registered with '" + name + "' name", this);

				return false;
			} 
			else
			{
				mMap.put(name, element);
				onRegister(name, element);
				return true;
			}
		}

		/**
		 * Unregisters object registered with identifier name.
		 * 
		 * @param	name	Key identifier
		 * 
		 * @return 	<code>true</code> if success
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function unregister(name : String) : Boolean
		{
			if ( isRegistered(name) )
			{
				mMap.remove(name);
				onUnregister(name);
				return true;
			} 
			else
			{
				return false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function locate(name : String) : Object
		{
			if ( isRegistered(name) ) 
			{
				return mMap.get(name);
			} 
			else
			{
				throw new PXNoSuchElementException("Can't find '" + type.toString() + "' item with '" + name + "' name", this);
			}
		}
		
		/**
		 * Clears all association between keys and objects
		 * registered for this locator and release all locator listeners.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function release() : void
		{
			clear();
			mMap = null;
			
			_logger = null ;
			
			if(_oEB) _oEB.removeAllListeners();
			_oEB = null;
		}
		
		/**
		 * Clears all association between keys and objects
		 * registered for this locator.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void
		{
			if(mMap) mMap.clear();
		}
		
		/**
		 * @inheritDoc
		 */
		public function add(dico : Dictionary) : void
		{
			for ( var key : * in dico ) 
			{
				try
				{
					register(key, dico[ key ]);
				} 
				catch (e : PXIllegalArgumentException)
				{
					e.message = "add() fails. " + e.message;
					throw(e);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function matchType( element : * ) : Boolean
		{
			return element is _cType || element == null;
		}

		/**
		 * @copy net.pixlib.events.PXBroadcaster#addEventListener()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply(_oEB, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}

		/**
		 * @copy net.pixlib.events.PXBroadcaster#removeEventListener()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener(type, listener);
		}
		
		/**
		 * Adds the passed-in listener as listener for all events dispatched
		 * by this event broadcaster. The function returns <code>true</code>
		 * if the listener have been added at the end of the call. If the
		 * listener is already registered in this event broadcaster the function
		 * returns <code>false</code>.
		 * <p>
		 * Note : The <code>addListener</code> function doesn't accept functions
		 * as listener, functions could only register for a single event.
		 * </p>
		 * @param	listener	the listener object to add as global listener
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	<code>PXIllegalArgumentException</code> — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster
		 * @throws 	<code>PXIllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addListener( listener : PXLocatorListener ) : Boolean
		{
			return _oEB.addListener(listener);
		}
		
		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster
		 * @throws 	<code>PXIllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeListener( listener : PXLocatorListener ) : Boolean
		{
			return _oEB.removeListener(listener);
		}
		
		/**
		 * Takes all values of a Locator and pass them one by one as arguments
		 * to a method of an object.
		 * It's exactly the same concept as batch processing in audio or video
		 * software, when you choose to run the same actions on a group of files.
		 * <p>
		 * Basical example which sets _alpha value to .4 and scale to 50
		 * on all MovieClips nested in the Locator instance:
		 * </p>
		 * 
		 * @example
		 * <listing>
		 * 
		 * function changeAlpha( mc : MovieClip, a : Number, s : Number )
		 * {
		 *      mc._alpha = a;
		 *      mc._xscale = mc._yscale = s;
		 * }
		 *
		 * locator.batchOnAll( changeAlpha, .4, 50 );
		 * </listing>
		 *
		 * @param	f		function to execute on each value stored in the locator.
		 * @param 	args	additionnal parameters.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function batchOnAll( method : Function, ...args ) : void
		{
			batch.apply(this, (args.length > 0 ) ? [values, method].concat(args) : [values, method]);
		}

		/**
		 * Takes values by type in Locator and pass them one by one as arguments
		 * to a method of an object.
		 * It's exactly the same concept as batch processing in audio or video
		 * software, when you choose to run the same actions on a group of files.
		 * <p>
		 * Basical example which sets _alpha value to .4 and scale to 50
		 * on all MovieClips nested in the Locator instance:
		 * </p>
		 * 
		 * @example
		 * <listing>
		 * 
		 * function changeAlpha( mc : MovieClip, a : Number, s : Number )
		 * {
		 *      mc._alpha = a;
		 *      mc._xscale = mc._yscale = s;
		 * }
		 *
		 * locator.batchOnType( MovieClip, changeAlpha, .4, 50 );
		 * </listing>
		 * 
		 * @param	type	Value type filter.
		 * @param	f		function to execute on each value stored in the locator.
		 * @param 	args	additionnal parameters.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function batchOnType( type : Class, method : Function, ...args ) : void
		{
			batch.apply(this, (args.length > 0 ) ? [getTypedValues(type), method].concat(args) : [getTypedValues(type), method]);
		}
		
		/**
		 * Takes all values of a Locator and call on each value the method name
		 * passed as 1st argument.
		 * <p>
		 * Basical example which plays all MovieClips from frame 10.
		 * </p>
		 * 
		 * @example
		 * <listing>
		 *
		 * locator.callOnAll( "gotoAndPlay", 10 );
		 * </listing>
		 *
		 * @param	methodName	method name to call on each value stored in the locator.
		 * @param 	args		additionnal parameters.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function callOnAll( methodName : String, ...args ) : void
		{
			call.apply(this, (args.length > 0 ) ? [values, methodName].concat(args) : [values, methodName]);
		}

		/**
		 * Takes values by type in Locator and call on each value the method name
		 * passed as 1st argument.
		 * <p>
		 * Basical example which plays all MovieClips from frame 10.
		 * </p>
		 * 
		 * @example
		 * <listing>
		 *
		 * locator.callOnType( MovieClip, "gotoAndPlay", 10 );
		 * </listing>
		 *
		 * @param	type		Value type filter.
		 * @param	methodName	method name to call on each value.
		 * @param 	args		additionnal parameters.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function callOnType( type : Class, methodName : String, ...args ) : void
		{
			call.apply(this, (args.length > 0 ) ? [getTypedValues(type), methodName].concat(args) : [getTypedValues(type), methodName]);
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			var hasType : Boolean = type != null;
			var parameter : String = "";

			if ( hasType )
			{
				parameter = type.toString();
				parameter = "<" + parameter.substr(7, parameter.length - 8) + ">";
			}

			return PXStringifier.process(this) + parameter;
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Call this method to do something when an object is registered 
		 * in locator.
		 * 
		 * @param	name	Name of the registered object
		 * @param	o		The registered object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onRegister( name : String = null, o : Object = null ) : void
		{
			broadcastEvent(getLocatorEvent(getOnRegisterEventType(), name, o));
		}

		/**
		 * Call this method to do something when an object is unregistered 
		 * from locator.
		 * 
		 * @param	name	Name of the registered object
		 * @param	o		The registered object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onUnregister( name : String = null ) : void
		{
			broadcastEvent(getLocatorEvent(getOnUnregisterEventType(), name));
		}

		/**
		 * Returns event type for "onRegister" event.
		 * 
		 * @default onRegisterObject
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getOnRegisterEventType(  ) : String
		{
			return PXLocatorEvent.onRegisterObjectEVENT;
		}

		/**
		 * Returns event type for "onUnregister" event.
		 * 
		 * @default onUnregisterObject
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getOnUnregisterEventType(  ) : String
		{
			return PXLocatorEvent.onUnregisterObjectEVENT;
		}

		/**
		 * Builds locator event structure.
		 * 
		 * <p>Overrides to use custom event type.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getLocatorEvent( type : String, key : String = null, o : Object = null ) : PXLocatorEvent
		{
			return new PXLocatorEvent(type, this, key, o);
		}

		/**
		 * @copy net.pixlib.events.PXBroadcaster#broadcastEvent()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function broadcastEvent( e : Event ) : void
		{
			_oEB.broadcastEvent(e);
		}

		/**
		 * Returns event <code>PXBroadcaster</code> owned by this locator.
		 * 
		 * @return The event <code>PXBroadcaster</code> owned by this locator.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getBroadcaster() : PXBroadcaster
		{
			return _oEB;
		}

		/**
		 * Returns a collection of registered values depending of passed-in 
		 * value <code>type</code>.
		 * 
		 * @param	type	Class type filter
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getTypedValues( type : Class = null ) : Array
		{
			var list : Array = new Array();
			
			if( type != null )
			{
				for each (var value : * in values )
				{
					if( value is type ) list.push(value);
				}
			}
			else return values;
			
			return list;
		}

		/**
		 * Process batch on passed-in collection using passed-in method.
		 * 
		 * @param collection 	Collection to use
		 * @param method		Method to call
		 * @param args			optional arguments
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function batch( collection : Array, method : Function, ...args ) : void
		{
			var length : int = collection.length;
			for( var i : int;i < length ;++i ) method.apply(null, (args.length > 0 ) ? [collection[i]].concat(args) : [collection[i]]);
		}

		/**
		 * Process call on passed-in collection using passed-in method.
		 * 
		 * @param collection 	Collection to use
		 * @param method		Method to apply
		 * @param args			optional arguments
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function call( collection : Array, methodName : String, ...args ) : void
		{
			var length : int = collection.length;
			for( var i : int;i < length ;++i )
			{
				var target : Object = collection[i];
				if ( target.hasOwnProperty(methodName) && target[ methodName ] is Function )
				{
					(target[ methodName ]).apply(null, args);
				} 
				else
				{
					throw new PXUnsupportedOperationException(".callMethodOnAllValues() failed. " + getQualifiedClassName(target) + "' class doesn't implement '" + methodName + "'", this);
				}
			}
		}
	}
}
