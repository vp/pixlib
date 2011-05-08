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
package net.pixlib.tms.bundles
{
	import net.pixlib.commands.PXCommand;
	import net.pixlib.commands.PXCommandListener;
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.exceptions.PXIllegalStateException;
	import net.pixlib.log.PXDebug;
	import net.pixlib.services.PXService;
	import net.pixlib.services.PXServiceEvent;
	import net.pixlib.services.PXServiceListener;

	import flash.events.Event;
	
	/**
	 * The PXLoadableBundle class allow to load Language bundle using 
	 * external data and service API.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 *  
	 * @author Romain Ecarnot
	 */
	final public class PXLoadableBundle extends PXLanguageBundle implements PXCommand, PXServiceListener
	{
		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------
		
		/** 
		 * Loading state.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bLoaded : Boolean;

		/** 
		 * Running state.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bRunning : Boolean;

		/** 
		 * Base concrete LocalBundle
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bundle : PXILanguageBundle;

		/** 
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var service : PXService;
		
		/** 
		 * EventBroadcaster for this instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var broadcaster : PXEventBroadcaster;


		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Creates a new instance
		 * 
		 * @param bundle	ILanguageBundle object used to store loading result
		 * @param service	Service to use to load bundle content
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXLoadableBundle(bundle : PXILanguageBundle, service : PXService)
		{
			super(bundle.language, null, bundle.id);
			
			this.bundle = bundle;
			this.service = service;
			
			bLoaded = false;
			bRunning = false;

			broadcaster = new PXEventBroadcaster(this);
		}

		/**
		 * @inheritDoc
		 */
		override public function hasResource(resourceName : String) : Boolean
		{
			if ( !bLoaded )
			{
				PXDebug.ERROR("Bundle named '" + bundle.id + "' is not loaed.", this);
				return false;
			}

			return bundle.hasResource(resourceName);
		}

		/**
		 * @inheritDoc
		 */
		override public function getResource(resourceName : String) : String
		{
			if ( !bLoaded )
			{
				PXDebug.ERROR("Bundle named '" + bundle.id + "' is not loaded.", this);
				return null;
			}

			return bundle.getResource(resourceName);
		}

		/**
		 * @private
		 */
		public function get loaded() : Boolean
		{
			return bLoaded;
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------

		/**
		 * @private
		 */
		public function execute(event : Event = null) : void
		{
			if (service != null)
			{
				if (!bLoaded)
				{
					service.addListener(this);
					service.execute();
				}
				else fireCommandEndEvent();
			}
			else
			{
				var msg : String = ".execute() failed. No loading service is defined for '" + bundle.id + "' bundle.";
				throw new PXIllegalStateException(msg, this);
			}
		}
		
		/**
		 * @private
		 */
		public function fireCommandEndEvent() : void
		{
			if (service) service.removeListener(this);

			broadcaster.broadcastEvent(new PXCommandEvent(PXCommandEvent.onCommandEndEVENT, this));
		}

		/**
		 * @private
		 */
		public function addCommandListener(listener : PXCommandListener, ... rest) : Boolean
		{
			return (broadcaster.addEventListener.apply(broadcaster, rest.length > 0 ? [PXCommandEvent.onCommandStartEVENT, listener].concat(rest) : [PXCommandEvent.onCommandStartEVENT, listener]) && broadcaster.addEventListener.apply(broadcaster, rest.length > 0 ? [PXCommandEvent.onCommandEndEVENT, listener].concat(rest) : [PXCommandEvent.onCommandEndEVENT, listener]));
		}

		/**
		 * @private
		 */
		public function removeCommandListener(listener : PXCommandListener) : Boolean
		{
			return (broadcaster.removeEventListener(PXCommandEvent.onCommandStartEVENT, listener) && broadcaster.removeEventListener(PXCommandEvent.onCommandEndEVENT, listener));
		}

		/**
		 * @private
		 */
		public function run() : void
		{
			execute();
		}

		/**
		 * @private
		 */
		public function get running() : Boolean
		{
			return service ? service.running : false;
		}

		/**
		 * @private
		 */
		public function onDataResult(event : PXServiceEvent) : void
		{
			bLoaded = true;
			
			bundle.content = event.result;

			fireCommandEndEvent();
		}

		/**
		 * @private
		 */
		public function onDataError(event : PXServiceEvent) : void
		{
			PXDebug.ERROR("Load() failed", this);

			fireCommandEndEvent();
		}

		/**
		 * @private
		 */
		public function onCommandStart(event : PXCommandEvent) : void
		{
			broadcaster.broadcastEvent(new PXCommandEvent(PXCommandEvent.onCommandStartEVENT, this));
		}

		/**
		 * @private
		 */
		public function onCommandEnd(event : PXCommandEvent) : void
		{
			fireCommandEndEvent();
		}
	}
}
