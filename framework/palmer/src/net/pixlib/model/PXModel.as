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
package net.pixlib.model 
{
	import net.pixlib.plugin.PXPlugin;

	import flash.events.Event;

	/**	 * Defines basic rules for implemented <code>PXModel</code>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre	 * @author Romain Ecarnot	 */	public interface PXModel 
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Model identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get name() : String;
		
		/**
		 * @private
		 */
		function set name(value : String) : void;
		
		/**
		 * Model <code>PXPlugin</code> owner.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get owner() : PXPlugin;

		/**
		 * @private
		 */
		function set owner(value : PXPlugin) : void;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Broascasts passed-in event to all view listeners.
		 * 
		 * @param event	Event to dispatch
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function notifyChanged( event : Event ) : void;

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#addListener
		 */
		function addListener( listener : PXModelListener ) : Boolean;

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#removeListener
		 */
		function removeListener( listener : PXModelListener ) : Boolean;

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#addEventListener
		 */
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#removeEventListener
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;

		/**
		 * Releases model.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function release() : void

		/**
		 * Returns string representation of instance.
		 * 
		 * @return the string representation of instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function toString() : String;
	}}