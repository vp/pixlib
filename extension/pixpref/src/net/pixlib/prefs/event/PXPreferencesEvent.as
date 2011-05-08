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
package net.pixlib.prefs.event 
{
	import net.pixlib.events.PXBasicEvent;
	import net.pixlib.prefs.PXPreferences;

	import flash.events.Event;

	/**
	 * The PXPreferencesEvent class is used during preference processes.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXPreferencesEvent extends PXBasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onPreferenceEdit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>name</code></td>
		 *     	<td>Preference name which is edited</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>oldValue</code></td>
		 *     	<td>Old preference value (before edition)</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>value</code></td>
		 *     	<td>Current preference value (after edition)</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>preferences</code>
		 *     	</td><td>The Preferences object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onPreferenceEdit
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public static const onPreferenceEditEVENT : String = "onPreferenceEdit";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onPreferenceDelete</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>name</code></td>
		 *     	<td>Preference name which is deleted</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>oldValue</code></td>
		 *     	<td>Old preference value (before deletion)</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>preferences</code>
		 *     	</td><td>The Preferences object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onPreferenceDelete
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public static const onPreferenceDeleteEVENT : String = "onPreferenceDelete";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onPreferencesLoad</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>preferences</code>
		 *     	</td><td>The Preferences object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onPreferencesLoad
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public static const onPreferencesLoadEVENT : String = "onPreferencesLoad";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onPreferencesSave</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>preferences</code>
		 *     	</td><td>The Preferences object</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onPreferencesSave
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public static const onPreferencesSaveEVENT : String = "onPreferencesSave";

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** 
		 * @private
		 * Property name
		 */
		private var _name : String; 

		/**
		 * @private
		 * Old property value
		 */
		private var _oldValue : *; 

		/**
		 * @private
		 * New property value
		 */
		private var _newValue : *; 

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Returns PXPreferences object carried by this event.
		 * 
		 * @return PXPreferences object carried by this event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get preferences() : PXPreferences
		{
			return target as PXPreferences;
		}
		
		/**
		 * The property name (if exist for this event)
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get name() : String
		{
			return _name;		
		}

		/**
		 * The old value of a changed property (if exist in this event)
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get oldValue() : *
		{
			return _oldValue;
		}

		/**
		 * The new property value. (if exist in this event)
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get value() : *
		{
			return _newValue;
		}
	
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new instance.
		 * 
		 * @param	type			Name of the event type
		 * @param	prefs			Preferences object carried by this event		 * @param	name			(optional) Preference name carried by this event
		 * @param 	oldValue		(optional) Old property value
		 * @param 	newValue		(optional) New property value
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXPreferencesEvent( type : String, prefs : PXPreferences, name : String = null, oldValue : * = null, newValue : * = null )
		{
			super(type, prefs);
			
			_name = name;
			_oldValue = oldValue;
			_newValue = newValue;
		}

		/**
		 * Returns instance clone.
		 * 
		 * @return instance clone
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function clone() : Event
		{
			return new PXPreferencesEvent(type, preferences, _name, bubbles, cancelable);	
		}
	}
}
