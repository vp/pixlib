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
package net.pixlib.plugin
{
	import net.pixlib.events.PXEventChannel;
	import net.pixlib.log.PXLog;
	import net.pixlib.model.PXModel;
	import net.pixlib.view.PXView;

	import flash.events.Event;

	/**
	 * The PXPlugin interface defines rules for plugin implementation (IoC 
	 * context or not).
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 * @author 	Romain Ecarnot
	 */
	public interface PXPlugin 
	{
		/**
		 * Returns plugin's event channel.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get channel() : PXEventChannel;

		/**
		 * Returns plugin identifier.
		 * 
		 * <p>Based on Plugin channel.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get name() : String;
		
		/**
		 * Returns plugin's debug channel.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get logger() : PXLog;
		
		/**
		 * Fires events using dedicated event channel.
		 * 
		 * <p>Only listeners on this event channel can receive 
		 * the event.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function fireExternalEvent( event : Event, channel : PXEventChannel ) : void;

		/**
		 * Fires events using public event channel.
		 * 
		 * <p>Each plugin who listen this type of event will be 
		 * triggered.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function firePublicEvent( event : Event ) : void;

		/**
		 * Fires events using private ( internal ) event channel.
		 * 
		 * <p>These events can be only handled by this plugin itself.<br />
		 * Others plugins in context can't listen this event.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function firePrivateEvent( event : Event ) : void;

		/**
		 * Returns an <code>PXModel</code> instance if it is 
		 * registered in model locator with passed-in <code>key</code> 
		 * identifier.
		 * 
		 * @param	key	PXModel identifier to return.
		 * 
		 * @return	The model registered with passed-in key or <code>null</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function getModel( key : String ) : PXModel;

		/**
		 * Returns an <code>PXView</code> instance if it is 
		 * registered in view locator with passed-in <code>key</code> 
		 * identifier.
		 * 
		 * @param	key	PXView identifier to return.
		 * 
		 * @return	The view registered with passed-in key or <code>null</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function getView( key : String ) : PXView;

		/**
		 * Returns <code>true</code> if a model is registered in model 
		 * locator with passed-in <code>name</code>.
		 * 
		 * @param	name	Model identifier to search
		 * 
		 * @return <code>true</code> if a model is registered in model 
		 * locator with passed-in <code>name</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function isModelRegistered( name : String ) : Boolean;

		/**
		 * Returns <code>true</code> if a view is registered in view 
		 * locator with passed-in <code>name</code>.
		 * 
		 * @param	name	PXView identifier to search
		 * 
		 * @return <code>true</code> if a view is registered in model 
		 * locator with passed-in <code>name</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function isViewRegistered( name : String ) : Boolean;

		/**
		 * Triggered when all IoC processing is finished.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onApplicationInit( ) : void;
		
		/**
		 * Releases plugin component.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function release() : void;
	}
}