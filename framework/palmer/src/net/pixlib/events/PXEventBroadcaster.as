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
package net.pixlib.events 
{
	import net.pixlib.collections.PXCollection;
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.collections.PXIterator;
	import net.pixlib.collections.PXWeakCollection;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXUnsupportedOperationException;
	import net.pixlib.log.PXStringifier;

	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * The <code>PXEventBroadcaster</code> class is the cornerstone of
	 * the Pixlib event system. The main reason which explains the presence
	 * of this object whereas the existence of the native <code>EventDispatcher</code>
	 * class is the lack of flexibility of that class :
	 * <ul>
	 * <li>It's not possible to add an object as listener for many events in a single call.</li>
	 * <li>It's not possible to force the presence of specific function in a listener object.</li>
	 * <li>It's not possible to reuse an event previously dispatched without having to create
	 * a custom event object which overrides the <code>clone</code> function.</li>
	 * </ul>
	 * <p>
	 * With the <code>PXEventBroadcaster</code> class it's possible to work with many kinds
	 * of listeners, as listed below :
	 * <ul>
	 * <li>Method closure. You simply have to pass a reference to the function in function 
	 * for register/unregister listeners, then that method is called with the event object 
	 * as argument.</li>
	 * <li>Objects implementing specific listener interface (as with Swing in java), in that
	 * case the function with the same name that the event type is called with the event
	 * object as argument.</li>
	 * <li>An object which implements the <code>handleEvent</code> function, in that case, 
	 * if the object doesn't have a function with a name corresponding to the event type
	 * the <code>handleEvent</code> function is called with the event object as argument.</li>
	 * </ul>
	 * </p><p>
	 * The Pixlib's event broadcaster also offer many methods to dispatch event from
	 * different type of events object. More formally, it's possible to dispatch 
	 * an event object, or an anonymous object which will be converted into a 
	 * <code>PXDynamicEvent</code> before the broadcast, all of its properties are
	 * then copied into this event object.
	 * </p><p>
	 * Another big difference with the native dispatcher is the fact that listeners
	 * are systematically stored using weak references, restricting the usage of
	 * anonymous listeners which can't be unregistered due to the lack of reference
	 * to it. 
	 * </p><p>
	 * Composition is privileged over inheritance by the use of a source object 
	 * parameter for the broadcaster. That property, if set, result in that all
	 * event objects dispatched by the <code>PXEventBroadcaster</code> which have
	 * their <code>target</code> set to <code>null</code> will have that object
	 * as source instead of the dispatcher itself.
	 * </p><p>
	 * Optionally the <code>PXEventBroadcaster</code> can restrict the type 
	 * of listeners to a specific type, in that case the broadcaster only
	 * accept the registration of objects which implements or extends the
	 * specified <code>Class</code>.
	 * </p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public class PXEventBroadcaster implements PXBroadcaster
	{
		/**
		 * @private
		 */
		static private var _oI : PXEventBroadcaster = null;
		
		/**
		 * @private
		 */
		protected var _oSource : Object;
		
		/**
		 * @private
		 */
		protected var _mAll : PXCollection;
		
		/**
		 * @private
		 */
		protected var _mType : Dictionary;
		
		/**
		 * @private
		 */
		protected var _nType : int;
		
		/**
		 * @private
		 */
		protected var _mEventListener : PXHashMap;
		
		/**
		 * @private
		 */
		protected var _mCallbackArgs : Dictionary;
		
		/**
		 * @private
		 */
		protected var _cType : Class;

		
		/**
		 * Creates an new <code>PXEventBroadcaster</code> object with the passed-in
		 * <code>source</code> object as source for events. If the <code>source</code>
		 * parameter is omitted the source of events will be this event broadcaster.
		 * <p>
		 * Optionnaly the type of listeners objects can be restricted, in that
		 * case you just have to pass the class of listener in the <code>type</code>
		 * parameter.
		 * </p> 
		 * @param	source	an object used as target instead of this event broadcaster
		 * 					for event object which have a <code>null</code> target
		 * @param	type	an optional class for listener
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXEventBroadcaster( source : Object = null, type : Class = null )
		{
			_oSource = ( source == null ) ? this : source;

			_mAll = new PXWeakCollection();
			_mType = new Dictionary();
			_mEventListener = new PXHashMap();
			_mCallbackArgs = new Dictionary();

			setListenerType(type);
		}

		/**
		 * Returns a static instance of the class.
		 * <p>
		 * The presence of a <code>getInstance</code> method in the
		 * <code>PXEventBroadcaster</code> class doesn't mean that the class
		 * is a singleton, it's simply a convenient way to let application
		 * developers broadcasting events that correspond to user gestures
		 * and requests over the whole application.
		 * </p>
		 * 
		 * @return a static instance of the class
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXEventBroadcaster
		{
			if ( !(PXEventBroadcaster._oI is PXEventBroadcaster) ) 
				PXEventBroadcaster._oI = new PXEventBroadcaster();
			return PXEventBroadcaster._oI;
		}

		/**
		 * Returns <code>true</code> if this event broadcaster has 
		 * listeners for the passed-in event type.
		 * 
		 * @param	type	name of the event for which look for listener
		 * @return	<code>true</code> if this event broadcaster has 
		 * 			listeners for the passed-in event type
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function hasListenerCollection( type : String ) : Boolean
		{
			return _mType[type] != null;
		}

		/**
		 * Defines the type of listeners this event broadcaster support.
		 * Functions are not concerned by this restriction.
		 *  
		 * @param	type	the type of the listener this event broadcaster support
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If one of the listener
		 * 			already contained in this event broadcaster doesn't match the
		 * 			passed-ni type.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setListenerType( type : Class ) : void
		{
			var i : PXIterator = _mAll.iterator();
			while ( i.hasNext() )
			{
				var listener : Object = i.next();
				if ( !(listener is Function && !(listener is type) ) )
				{
					var msg : String = this + ".setListenerType( " + type + " ) failed, your listener must be '" + _cType + "' typed";

					throw new PXIllegalArgumentException(msg, this);
				}
			}

			_cType = type;
		}

		/**
		 * Returns a <code>PXCollection</code> view of listeners for the passed-in
		 * event type. The returned collection is a reference to the internal collection
		 * of this event broadcaster, resulting that there's no guarantee that collection
		 * cannot be altered by another object. If the <code>type</code> parameter is
		 * omitted, the function returns the collection of global listeners objects (all
		 * objects that haven't register for a specific event).
		 * 
		 * @param	type	the event name for which get a collection, if not
		 * 					defined, the collection of global listeners  is returned.
		 * 					
		 * @return	<code>PXCollection</code> of listeners corresponding to the
		 * 			passed-in event type
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getListenerCollection( type : String = null ) : PXCollection
		{
			return ( type != null ) ? _mType[type] : _mAll;
		}

		/**
		 * Removes the complete collection of listeners for a specified
		 * event type.
		 * 
		 * @param	type	the event type for which remove all listeners
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeListenerCollection( type : String ) : void
		{
			if ( hasListenerCollection(type) )
			{
				var i : PXIterator = _mType[type].iterator();
				while ( i.hasNext() ) _removeReference(type, i.next());
				_mType[type] = null;
			}
		}

		/**
		 * Returns <code>true</code> if the passed-in listener object is registered
		 * as listener for the passed-in event type. If the <code>type</code> parameter
		 * is omitted, the function returns <code>true</code> only if the listener is 
		 * registered as global listener.
		 * <p>
		 * Note : the listener could be either an object or a function.
		 * </p>
		 * 
		 * @param	listener	object to look for registration
		 * @param	type		event type to look at
		 * @return	<code>true</code> if the passed-in listener should receive notification
		 * 			of the passed-in event type
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isRegistered( listener : Object, type : String = null ) : Boolean
		{
			if (type == null)
			{
				return _mAll.contains(listener);
			} 
			else
			{
				if ( hasListenerCollection(type) )
				{
					return getListenerCollection(type).contains(listener);
				} 
				else
				{
					return false;
				}
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
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster and is not a Function.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addListener( listener : Object ) : Boolean
		{
			if ( _cType != null && !( listener is _cType ) && !(listener is Function) )
			{
				var msg : String = this + ".addListener( " + listener + " ) failed, your listener must be '" + _cType + "' typed";
			
				throw new PXIllegalArgumentException(msg, this);
				return false;
			} 
			else
			{
				if ( _mAll.add(listener) ) 
				{
					_flushReference(listener);
					return true;
				} 
				else
				{
					return false;
				}
			}
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
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeListener( listener : Object ) : Boolean
		{
			var b : Boolean = _flushReference(listener);
			b = b || _mAll.contains(listener);
			_mAll.remove(listener);
			return b;
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
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addEventListener( type : String, listener : Object, ...rest ) : Boolean
		{
			if ( !( isRegistered(listener) ) )
			{
				if ( listener is Function && rest )
				{
					_mCallbackArgs[listener] = rest;
				} 
				else if ( listener.hasOwnProperty(type) && ( listener[type] is Function ) )
				{
					
				} 
				else if ( listener.hasOwnProperty("handleEvent") && listener.handleEvent is Function )
				{
					
				} 
				else
				{
					var msg : String;
					msg = this + ".addEventListener() failed, you must implement '" + type + "' method or 'handleEvent' method in '" + getQualifiedClassName(listener) + "' class";

					throw new PXUnsupportedOperationException(msg, this);
				}

				if ( !(hasListenerCollection(type)) ) _mType[type] = new PXWeakCollection();

				if ( getListenerCollection(type).add(listener) ) 
				{
					_storeReference(type, listener);
					_nType++;
					return true;
				} 
				else
				{
					return false;
				}
			} 
			else
			{
				return false;
			}
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
			if ( hasListenerCollection(type) )
			{
				var c : PXCollection = getListenerCollection(type);

				if ( c.remove(listener) )
				{
					_removeReference(type, listener);
					if ( c.empty ) removeListenerCollection(type);
					_nType--;
					return true;
				} 
				else
				{
					return false;
				}
			} 
			else
			{
				return false;
			}
		}

		/**
		 * Removes all listeners registered in this event broadcaster.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAllListeners() : void
		{
			_mAll.clear();
			_mType = new Dictionary();
			_nType = 0;
			_mEventListener.clear();
			_mCallbackArgs = new Dictionary();
		}
		
		/**
		 * Returns <code>true</code> if this event broadcaster contains
		 * no listeners for any event.
		 * 
		 * @return 	<code>true</code> if this event broadcaster contains
		 * 			no listeners for any event.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isEmpty() : Boolean
		{
			return _mAll.empty && (_nType == 0);
		}

		/**
		 * Broadcast an event using an anonymous object. 
		 * The only requirement for objects passed as argument in
		 * this function is that they must have a <code>type</code>
		 * property. The <code>target</code> property will be set
		 * with this event broadcaster's source if there is no source
		 * specified.
		 * <p>
		 * The concret event object broadcasted to listener is a
		 * <code>PXDynamicEvent</code> decorated with the property
		 * of the passed-in object.
		 * </p>
		 * @param	o	an anonymous object used to decorate a
		 * 				<code>PXDynamicEvent</code>
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function dispatchEvent( o : Object ) : void
		{
			if( o["type"] == null )
			{
				throw new PXIllegalArgumentException(".dispatchEvent() fails. " + o + " event has no type.", this);
			}

			var e : PXDynamicEvent = new PXDynamicEvent(o["type"]);
			for ( var p : String in o ) if (p != "type") e[p] = o[p];
			broadcastEvent(e);
		}

		/**
		 * Broadcast the passed-in event object to listeners
		 * according to the event's type. The event is broadcasted
		 * to both listeners registered specifically for this event
		 * type and global listeners in the broadcaster.
		 * <p>
		 * If the <code>target</code> property of the passed-in event
		 * is <code>null</code>, it will be set using the value of the
		 * source property of this event broadcaster.
		 * </p>
		 * 
		 * @param	e	event object to broadcast
		 * 
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function broadcastEvent( e : Event ) : void
		{
			if( e.target == null && e is PXBasicEvent ) (e as PXBasicEvent).target = _oSource;
			
			if ( hasListenerCollection(e.type) ) _broadcastEvent(getListenerCollection(e.type), e);
			if ( !(_mAll.empty) ) _broadcastEvent(_mAll, e);
		}

		/**
		 * Broadcast the passed-in event to the listeners contained in the passed-in
		 * <code>PXCollection</code>.
		 * 
		 * @param	c	<code>PXCollection</code> of listeners to which send the event
		 * @param	e	event to broadcast to listeners
		 * 
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _broadcastEvent( c : PXCollection, e : Event ) : void
		{
			var type : String = e.type;
			var a : Array = c.toArray();
			var l : Number = a.length;

			while ( --l > -1 ) 
			{
				var listener : Object = a[l];

				if ( listener is Function )
				{
					(listener as Function).apply(null, (_mCallbackArgs[listener] != null) ? [e].concat(_mCallbackArgs[listener]) : [e]);
				} else if ( listener.hasOwnProperty(type) && listener[ type ] is Function )
				{
					listener[type](e);
				} else if ( listener.hasOwnProperty("handleEvent") && listener.handleEvent is Function )
				{
					listener.handleEvent(e);
				} 
				else 
				{
					var msg : String;
					msg = this + ".broadcastEvent() failed, you must implement '" + type + "' method or 'handleEvent' method in '" + getQualifiedClassName(listener) + "' class";

					throw new PXUnsupportedOperationException(msg, this);
				}
			}
		}

		/**
		 * Returns string representation of this instance.
		 * 		   
		 * @return string representation of this instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			var hasType : Boolean = _cType != null;
			var parameter : String = "";
			
			if( hasType )
			{
				parameter = _cType.toString();
				parameter = "<" + parameter.substr(7, parameter.length - 8) + ">";
			}
			
			return PXStringifier.process(this) + parameter;
		}

		/**
		 * @private
		 */
		private function _storeReference( type : String, listener : Object ) : void
		{
			if ( !(_mEventListener.containsKey(listener)) ) _mEventListener.put(listener, new PXHashMap());
			_mEventListener.get(listener).put(type, listener);
		}

		/**
		 * @private
		 */
		private function _removeReference( type : String, listener : Object ) : void
		{
			if ( listener is Function && (_mCallbackArgs[listener] != null) ) _mCallbackArgs[listener] = null;

			var m : PXHashMap = _mEventListener.get(listener);
			m.remove(type);
			if ( m.empty ) _mEventListener.remove(listener);
		}

		/**
		 * @private
		 */
		private function _flushReference( listener : Object ) : Boolean
		{
			if ( listener is Function && (_mCallbackArgs[listener] != null) ) _mCallbackArgs[listener] = null;

			var b : Boolean = false;
			var m : PXHashMap = _mEventListener.get(listener);
			if ( m != null )
			{
				var a : Array = m.keys;
				var l : Number = a.length;
				while( --l > -1 ) b = removeEventListener(a[l], listener) || b;
				_mEventListener.remove(listener);
			}
			return b;
		}
	}
}