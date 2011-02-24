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
package net.pixlib.load 
{
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXEventChannel;
	import net.pixlib.load.strategy.PXLoaderStrategy;
	import net.pixlib.plugin.PXChannelExpert;
	import net.pixlib.plugin.PXPlugin;

	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	/**
	 * The PXPluginLoader class allow to load Pixlib Plugin at runtime.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXPluginLoader extends PXAbstractLoader
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**
		 * Stores loaded plugin instance.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var plugin : PXPlugin; 

		/**
		 * Plugin full qualified classpath.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var pluginClassPath : String; 

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param key			Identifier's name for loader instance.
		 * @param classpath		Loaded plugin full qualified classpath
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXPluginLoader(key : String, classpath : String) 
		{
			super(new PXLoaderStrategy());
			
			name = key;
			
			pluginClassPath = classpath;
		}

		/**
		 * @inheritDoc
		 */
		final override public function set content(value : Object) : void
		{	
			try
			{
				PXChannelExpert.getInstance().registerChannel(new PXEventChannel(pluginClassPath));
				var pluginClass : Class = getDefinitionByName(pluginClassPath) as Class;
				var plugin : PXPlugin = new pluginClass();
				PXCoreFactory.getInstance().register(name, plugin);
				
				value = plugin;
			}
			catch(e : Error)
			{
			}
			finally
			{
				super.content = value;
			}
		}

		/**
		 * Returns loaded plugin instance.
		 * 
		 * @return loaded plugin instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function getPlugin() : PXPlugin
		{
			return content as PXPlugin;
		}

		/**
		 * Returns a LoaderInfo object corresponding to the object being loaded.
		 * 
		 * @return A LoaderInfo object corresponding to the object being loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function get contentLoaderInfo() : LoaderInfo
		{
			return PXLoaderStrategy(strategy).contentLoaderInfo;
		}

		/**
		 * Returns the <code>applicationDomain</code> of loaded display object.
		 * 
		 * @return The <code>applicationDomain</code> of loaded display object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function getApplicationDomain() : ApplicationDomain
		{
			return ( strategy as PXLoaderStrategy ).contentLoaderInfo.applicationDomain;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function release() : void
		{
			getPlugin().release();
			
			super.release();
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		final  override protected function onInitialize() : void
		{
			if(getPlugin() is PXPlugin)
			{
				super.onInitialize();
			}
			else
			{
				fireEventType(PXLoaderEvent.onLoadErrorEVENT, "Plugin loading failed! Plugin '" + pluginClassPath + "' not exist in loaded domain.");
			}
		}
	}
}
