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
	import flash.events.Event;		

	/**
	 * The PXBroadcaster interface defines contract for event dispatcher 
	 * instances.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public interface PXBroadcaster 
	{
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
		 * 
		 * @param	listener	the listener object to add as global listener.
		 * 
		 * @return	<code>true</code> if the listener have been added during this call.
		 * 
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in listener
		 * 			is a function
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function addListener( listener : Object ) : Boolean;

		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object.
		 * 						
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in listener
		 * 			is a function.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function removeListener( listener : Object ) : Boolean;

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
		 * A <code>PXDelegate</code> object is created and then
		 * added as listener for the event type. There is no restriction on the name of 
		 * the function. If the <code>rest</code> is not empty, all elements in it is 
		 * used as additional arguments into the delegate object. </li>
		 * </ol>
		 * 
		 * @param	type		name of the event for which register the listener
		 * @param	listener	object or function which will receive this event
		 * @param	rest		additional arguments for the function listener
		 * 
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function addEventListener( type : String, listener : Object, ...rest ) : Boolean;

		/**
		 * Removes the passed-in listener for listening the specified event. The
		 * listener could be either an object or a function.
		 * 
		 * @param	type		name of the event for which unregister the listener.
		 * @param	listener	object or function to be unregistered.
		 * 
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;

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
		 * @param	event	event object to broadcast.
		 * 
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function broadcastEvent( event : Event ) : void;

		/**
		 * Removes all listeners registered in this event broadcaster.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function removeAllListeners() : void;

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
		function hasListenerCollection( type : String ) : Boolean;

		/**
		 * Returns <code>true</code> if the passed-in listener object is registered
		 * as listener for the passed-in event type. If the <code>type</code> parameter
		 * is omitted, the function returns <code>true</code> only if the listener is 
		 * registered as global listener.
		 * <p>
		 * Note : the listener could be either an object or a function.
		 * </p>
		 * 
		 * @param	listener	object to look for registration.
		 * @param	type		event type to look at.
		 * 
		 * @return	<code>true</code> if the passed-in listener should receive notification
		 * 			of the passed-in event type.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function isRegistered( listener : Object, type : String = null ) : Boolean;	}}