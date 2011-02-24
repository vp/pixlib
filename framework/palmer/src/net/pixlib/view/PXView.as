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
package net.pixlib.view 
{
	import net.pixlib.model.PXModelListener;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.structures.PXDimension;

	import flash.events.Event;
	import flash.geom.Point;

	/**	 * The PXView interface defines rules for concrete implementations of 
	 * view in the Pixlib MVC Design.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre	 * @author Romain Ecarnot	 */	public interface PXView extends PXModelListener
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * View's identifier.
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
		 * View <code>PXPlugin</code> owner.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get owner() : PXPlugin;

		/**
		 * @private
		 */
		function set owner(value : PXPlugin) : void;
		
		/**
		 * View position.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get position() : Point;
		
		/**
		 * @private
		 */
		function set position(value : Point) : void;

		/**
		 * View size.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get size() : PXDimension;
		
		/**
		 * @private
		 */
		function set size(value : PXDimension) : void;
		
		/**
		 * View visible state.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get visible() : Boolean;
		
		/**
		 * @private
		 */
		function set visible(value : Boolean) : void;
		
		
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
		 * Shows view.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function show() : void;

		/**
		 * Hides view.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function hide() : void;

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#addListener
		 */
		function addListener( listener : PXViewListener ) : Boolean;

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#removeListener
		 */
		function removeListener( listener : PXViewListener ) : Boolean;

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#addEventListener
		 */
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#removeEventListener
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;

		/**
		 * Releases view.
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
		function toString() : String;	}}