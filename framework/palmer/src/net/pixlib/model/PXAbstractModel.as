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
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.events.PXEventChannel;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.plugin.PXBasePlugin;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.plugin.PXPluginDebug;

	import flash.events.Event;


	/**
	 *  Dispatched when model is initialized.
	 *  
	 *  @eventType net.pixlib.model.PXModelEvent.onInitModelEVENT
	 */
	[Event(name="onInitModel", type="net.pixlib.model.PXModelEvent")]
	
	/**
	 *  Dispatched when model is released.
	 *  
	 *  @eventType net.pixlib.model.PXModelEvent.onReleaseModelEVENT
	 */
	[Event(name="onReleaseModel", type="net.pixlib.model.PXModelEvent")]
	
	/**
	 * Abstract implementation of Model part of the MVC implementation.
	 * 
	 * @author Francis Bourre
	 * @author Romain Ecarnot
	 */
	public class PXAbstractModel implements PXModel
	{
		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------
		/** EventBroadcaster for this instance. */
		protected var oEB : PXEventBroadcaster;

		/** Instance identifier in <code>PXModelLocator</code>. */
		protected var sName : String;

		/** Plugin owner og this model. */
		protected var oOwner : PXPlugin;

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var event : PXModelEvent;

		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		public function get name() : String
		{
			return sName;
		}

		/**
		 * @private
		 */
		public function set name(value : String) : void
		{
			var loc : PXModelLocator = PXModelLocator.getInstance(owner);

			if (!(loc.isRegistered(value) ))
			{
				if (value != null && loc.isRegistered(value) ) loc.unregister(value);
				if (loc.register(value, this) ) sName = value;

				event.value = value;
			}
			else
			{
				logger.error("set name failed. '" + value + "' is already registered in ModelLocator.", this);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get owner() : PXPlugin
		{
			return oOwner;
		}

		/**
		 * @private
		 */
		public function set owner(value : PXPlugin) : void
		{
			oOwner = value ? value : PXBasePlugin.getInstance();
		}

		/**
		 * @inheritDoc
		 */
		public function get logger() : PXPluginDebug
		{
			return PXPluginDebug.getInstance(owner);
		}

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#setListenerType
		 */
		public function set listenerType(value : Class) : void
		{
			oEB.setListenerType(value);
		}

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		 * @private
		 */
		public function handleEvent(event : Event) : void
		{
			//
		}

		/**
		 * @inheritDoc
		 */
		public function notifyChanged(event : Event) : void
		{
			getBroadcaster().broadcastEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		public function release() : void
		{
			PXModelLocator.getInstance(owner).unregister(name);

			onReleaseModel();

			getBroadcaster().removeAllListeners();
			oEB = null;
			sName = null;
		}

		/**
		 * @inheritDoc
		 */
		public function addListener(listener : PXModelListener) : Boolean
		{
			return oEB.addListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function hasListener(listener : PXModelListener) : Boolean
		{
			return oEB.isRegistered(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function hasListenerCollectionType(type : String) : Boolean
		{
			return oEB.hasListenerCollection(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener(listener : PXModelListener) : Boolean
		{
			return oEB.removeListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListener(type : String, listener : Object, ... rest) : Boolean
		{
			return oEB.addEventListener.apply(oEB, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type : String, listener : Object) : Boolean
		{
			return oEB.removeEventListener(type, listener);
		}

		/**
		 * @inheritDoc
		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getBroadcaster() : PXEventBroadcaster
		{
			return oEB;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onInitModel() : void
		{
			event.type = PXModelEvent.onInitModelEVENT;
			notifyChanged(event);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onReleaseModel() : void
		{
			event.type = PXModelEvent.onReleaseModelEVENT;
			notifyChanged(event);
		}

		/**
		 * Fires passed-in <code>event</code> in private communication 
		 * channel.
		 * 
		 * <p>Private communication channel is used in MVC architecture.</p>
		 * 
		 * @param event	Event to broadcast.
		 * 
		 * @see net.pixlib.commands.PXFrontController
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function firePrivateEvent(event : Event) : void
		{
			owner.firePrivateEvent(event);
		}

		/**
		 * Fires passed-in <code>event</code> in public communication 
		 * channel.
		 * 
		 * <p>Public communication channel is used in Plugin architecture.</p>
		 * 
		 * @param event	Event to broadcast.
		 * 
		 * @see net.pixlib.commands.PXFrontController
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function firePublicEvent(event : Event) : void
		{
			owner.firePublicEvent(event);
		}

		/**
		 * Fires passed-in <code>event</code> in external communication 
		 * using dedicated channel.
		 * 
		 * <p>External communication channel is used in Plugin architecture.</p>
		 * 
		 * @param event	Event to broadcast.
		 * 
		 * @see net.pixlib.commands.PXFrontController
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function fireExternalEvent(event : Event, channel : PXEventChannel) : void
		{
			owner.fireExternalEvent(event, channel);
		}

		/**
		 * @private
		 */
		function PXAbstractModel(modelOwner : PXPlugin = null, modelName : String = null)
		{
			oEB = new PXEventBroadcaster(this);
			event = new PXModelEvent("", this, "");

			owner = modelOwner;
			if (modelName) name = modelName;
		}
	}
}