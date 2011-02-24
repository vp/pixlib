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
	import net.pixlib.commands.PXFrontController;
	import net.pixlib.commands.PXQueueController;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXApplicationBroadcaster;
	import net.pixlib.events.PXBroadcaster;
	import net.pixlib.events.PXEventChannel;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.log.PXLog;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.model.PXModel;
	import net.pixlib.model.PXModelLocator;
	import net.pixlib.utils.PXHashCode;
	import net.pixlib.view.PXView;
	import net.pixlib.view.PXViewLocator;

	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The PXAbstractPlugin class.
	 * 
	 * @author 	Francis Bourre
	 */
	public class PXAbstractPlugin implements PXPlugin
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Public broadcaster. */	
		protected var oEBPublic : PXBroadcaster;

		/** Plugin FrontController. */
		protected var oController : PXFrontController;

		/** Plugin QueueController. */
		protected var oQueueController : PXQueueController;

		/** Application's model locator. */
		protected var oModelLocator : PXModelLocator;

		/** Application's view locator. */
		protected var oViewLocator : PXViewLocator;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Plugin Front controller
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get controller() : PXFrontController
		{
			return oController;
		}

		/**
		 * Plugin Queue controller
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get queueController() : PXQueueController
		{
			return oQueueController;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get channel() : PXEventChannel
		{
			return PXChannelExpert.getInstance().getChannel(this);
		}

		/**
		 * @inheritDoc
		 */
		public function get name() : String
		{
			return channel.toString();	
		}
		
		/**
		 * @inheritDoc
		 */
		public function get logger() : PXLog
		{
			return PXPluginDebug.getInstance(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isModelRegistered( name : String ) : Boolean
		{
			return oModelLocator.isRegistered(name);
		}

		/**
		 * @inheritDoc
		 */
		public function getModel( key : String ) : PXModel
		{
			return oModelLocator.getModel(key);
		}

		/**
		 * @inheritDoc
		 */
		public function isViewRegistered( name : String ) : Boolean
		{
			return oViewLocator.isRegistered(name);
		}

		/**
		 * @inheritDoc
		 */
		public function getView( key : String ) : PXView
		{
			return oViewLocator.getView(key);
		}

		/**
		 * @inheritDoc
		 */
		public function fireExternalEvent( event : Event, externalChannel : PXEventChannel ) : void
		{
			if ( externalChannel != channel ) 
			{
				PXApplicationBroadcaster.getInstance().broadcastEvent(event, externalChannel);
			} 
			else
			{
				throw new PXIllegalArgumentException(".fireExternalEvent() failed, '" + externalChannel + "' is its public channel.", this);
			}
		}

		/**
		 * @private
		 * Generic event handler.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function handleEvent( event : Event = null ) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function firePublicEvent( event : Event ) : void
		{
			if( oEBPublic ) ( oEBPublic as PXPluginBroadcaster ).firePublicEvent(event, this);
				else logger.warn(this + " doesn't have public dispatcher", this);
		}

		/**
		 * @inheritDoc
		 */
		public function firePrivateEvent( event : Event ) : void
		{
			if ( oController.isRegistered(event.type) || oQueueController.isRegistered(event.type) ) 
			{
				if ( oController.isRegistered(event.type) ) oController.handleEvent(event);
				if ( oQueueController.isRegistered(event.type) ) oQueueController.handleEvent(event);
			} 
			else
			{
				logger.debug(this + ".firePrivateEvent() fails to retrieve command associated with '" + event.type + "' event type.", this);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationInit( ) : void
		{
			fireOnInitPlugin();
		}

		/**
		 * Releases plugin.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function release() : void
		{
			oController.release();
			oModelLocator.release();
			oViewLocator.release();

			var key : String = PXCoreFactory.getInstance().getKey(this);
			PXCoreFactory.getInstance().unregister(key);
			
			releaseInternal();
			
			fireOnReleasePlugin();
			
			oEBPublic.removeAllListeners();

			PXApplicationBroadcaster.getInstance().releaseChannelDispatcher(channel);
			PXPluginDebug.release(this);
			PXChannelExpert.getInstance().releaseChannel(this);
		}
		
		/**
		 * Adds passed-in plugin instance to receive all events broadcasted in 
		 * public channel by current plugin.
		 * 
		 * @param plugin PXPlugin instance to register as listener
		 * 
		 * @return <code>true</code> if instance is well registered as listener
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function addPluginListener(plugin : PXPlugin) : Boolean
		{
			return PXApplicationBroadcaster.getInstance().addListener(plugin, channel);
		}
		
		/**
		 * Removes passed-in plugin instance from receiving all events broadcasted in 
		 * public channel by current plugin.
		 * 
		 * @param plugin PXPlugin instance to unregister as listener
		 * 
		 * @return <code>true</code> if instance is well unregistered as listener
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function removePluginListener(plugin : PXPlugin) : Boolean
		{
			return PXApplicationBroadcaster.getInstance().removeListener(plugin, channel);
		}
		
		/**
		 * Adds passed-in plugin instance to receive event type broadcasted in 
		 * public channel by current plugin.
		 * 
		 * @param type	Event type to listen
		 * @param plugin PXPlugin instance to register as listener
		 * 
		 * @return <code>true</code> if instance is well registered as listener
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function addPluginEventListener(type : String, plugin : PXPlugin) : Boolean
		{
			return PXApplicationBroadcaster.getInstance().addEventListener(type, plugin, channel);
		}
		
		/**
		 * Removes passed-in plugin instance from receiving event type broadcasted in 
		 * public channel by current plugin.
		 * 
		 * @param type	Event type to stop listening
		 * @param plugin PXPlugin instance to unregister as listener
		 * 
		 * @return <code>true</code> if instance is well unregistered as listener
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function removePluginEventListener(type : String, plugin : PXPlugin) : Boolean
		{
			return PXApplicationBroadcaster.getInstance().removeEventListener(type, plugin, channel);
		}
		
		/**
		 * @copy net.pixlib.event.PXBroadcaster#addListener()
		 */
		final public function addListener( listener : PXPluginListener ) : Boolean
		{
			if( oEBPublic ) 
			{
				return oEBPublic.addListener(listener);
			} 
			else 
			{
				logger.warn(this + " doesn't have public dispatcher", this);
				return false;
			}
		}

		/**
		 * @copy net.pixlib.event.PXBroadcaster#removeListener()
		 */
		final public function removeListener( listener : PXPluginListener ) : Boolean
		{
			if( oEBPublic ) 
			{
				return oEBPublic.removeListener(listener);
			} 
			else 
			{
				logger.warn(this + " doesn't have public dispatcher", this);
				return false;
			}
		}

		/**
		 * @copy net.pixlib.event.PXBroadcaster#addEventListener()
		 */
		final public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			if( oEBPublic ) 
			{
				return oEBPublic.addEventListener.apply(oEBPublic, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
			} 
			else 
			{
				logger.warn(this + " doesn't have public dispatcher", this);
				return false;
			}
		}

		/**
		 * @copy net.pixlib.event.PXBroadcaster#removeEventListener()
		 */
		final public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			if( oEBPublic ) 
			{
				return oEBPublic.removeEventListener(type, listener);
			} 
			else 
			{
				logger.warn(this + " doesn't have public dispatcher", this);
				return false;
			}
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
			return PXStringifier.process(this);
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Only use it before super() call in constructor when plugin is not 
		 * used in IoC architecture to allow plugin communication.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected static function registerInternalChannel(plugin : PXPlugin) : void
		{
			var key : String = getQualifiedClassName(plugin) + PXHashCode.getKey(plugin);
			
			PXChannelExpert.getInstance().registerChannel(new PXEventChannel(key));
			PXCoreFactory.getInstance().register(key, plugin);
		}
		
		/**
		 * Inits plugin properties.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function initialize() : void
		{
			oController = new PXFrontController(this);
			oQueueController = new PXQueueController(this);
			oModelLocator = PXModelLocator.getInstance(this);
			oViewLocator = PXViewLocator.getInstance(this);
			
			oEBPublic = PXApplicationBroadcaster.getInstance().getChannelDispatcher(channel, this);
			if( oEBPublic ) oEBPublic.addListener(this);
		}
		
		/**
		 * Internal implementation to release plugin instance.
		 * 
		 * <p>releaseInternal method is called by release() metod before any 
		 * event dispatching and plugin core release actions().</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function releaseInternal() : void
		{
			
		}
		
		/**
		 * Plugin model'slocator.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function get modelLocator() : PXModelLocator
		{
			return oModelLocator;
		}

		/**
		 * Plugin view's locator.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function get viewLocator() : PXViewLocator
		{
			return oViewLocator;
		}

		/**
		 * Fires <code>PXPluginEvent.onInitPluginEVENT</code> public event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function fireOnInitPlugin() : void
		{
			firePublicEvent(new PXPluginEvent(PXPluginEvent.onInitPluginEVENT, this));
		}

		/**
		 * Fires <code>PXPluginEvent.onReleasePluginEVENT</code> public event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function fireOnReleasePlugin() : void
		{
			firePublicEvent(new PXPluginEvent(PXPluginEvent.onReleasePluginEVENT, this));
		}
		

		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * <p>Overrides <code>#initialize()</code> method to customize 
		 * plugin initialization process.</p>
		 * 
		 * @see #initialize()
		 */
		function PXAbstractPlugin() 
		{
			initialize();
		}			
	}
}