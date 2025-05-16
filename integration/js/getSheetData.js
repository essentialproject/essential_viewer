/* script for creating sheets in launchpad */

const generateStructure = (data, refMap, idType) => {
	return data
	  .map((item) => {
		let parentDetails = item.parentBusinessCapability.map((parent) => {
		  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id; // If refMap exists, use ref, otherwise use item.id
		  if(!idType){refValue=item.id}	
		  if (idType && !refMap[item.id]) {
			return null;
		  }
		  return {
			ID: refValue, // Use idType to determine whether to return item.id or refMap ref
			Name: item.name,
			Description: item.description,
			parent: item.rootCapability ? "" : parent.name,
			positioninparent: item.positioninParent,
			sequencenumber: item.sequenceNumber,
			rootCapability: item.rootCapability,
			businessDomain: item.businessDomain,
			level: item.level,
		  };
		}).filter(Boolean); //;
  
		if (!item.parentBusinessCapability.length) {
		  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id; // Same logic for items without parents
		  if(!idType){refValue=item.id}		
		  if (idType && !refMap[item.id]) {
			return null;
		  }
		  return {
			ID: refValue, // Use idType or refMap if idType is false
			Name: item.name,
			Description: item.description,
			parent: item.rootCapability ? "" : item.name,
			positioninparent: item.positioninParent,
			sequencenumber: item.sequenceNumber,
			rootCapability: item.rootCapability,
			businessDomain: item.businessDomain,
			level: item.level,
		  };
		}
  
		return parentDetails;
	  }).filter(Boolean)
	  .flat();
  };
  
const generateDomTable = (data) => {
  return data
    .map((item) => { 
      if (item.parentDomain && item.parentDomain.length) {
		const refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id; // If refMap exists, use ref, otherwise use item.id

		if (idType && !refMap[item.id]) {
		  return null;
		} 
        return item.parentDomain.map((parent) => ({
          id: refValue,
          name: item.name,
          description: item.description,
          parent: parent.name,
        })).filter(Boolean);
      } else {
		const refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id; // If refMap exists, use ref, otherwise use item.id
		if (idType && !refMap[item.id]) {
			return null;
		  }
        return {
          id: refValue,
          name: item.name,
          description: item.description,
          parent: "",
        };
      }
    }).filter(Boolean)
    .flat();
};
const generateProcessTable = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		
		if (!hasValidId) {
		  return null; // Skip this item if it doesn't have a valid ID
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		// If idType is true but no reference exists in refMap, skip this item
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		// Process parentCaps if they exist
		if (item.parentCaps && item.parentCaps.length) {
		  return item.parentCaps
			.map((parentCap) => ({
			  id: refValue,
			  name: item.name,
			  description: item.description,
			  parent_capability: parentCap.name,
			}))
			.filter(Boolean); // Remove null or invalid items
		} else {
		  // No parent capabilities, return default structure
		  return {
			id: refValue,
			name: item.name,
			description: item.description,
			parent_capability: "",
		  };
		}
	  })
	  .filter(Boolean) // Remove null items
	  .flat();
  };
  
  const generateProcessFamilyTable = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null; // Skip this item if it doesn't have a valid ID
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		// If idType is true but no reference exists in refMap, skip this item
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		// Process containedProcesses if they exist
		if (item.containedProcesses && item.containedProcesses.length) {
		  return item.containedProcesses
			.map((process) => ({
			  id: refValue,
			  name: item.name,
			  description: item.description,
			  process: process.name,
			}))
			.filter(Boolean);
		} else {
		  return {
			id: refValue,
			name: item.name,
			description: item.description,
			process: "",
		  };
		}
	  })
	  .filter(Boolean)
	  .flat();
  };

  const generateSites = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		// If idType is true but no reference exists in refMap, skip this item
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		return {
		  id: refValue,
		  name: item.name,
		  description: item.description,
		  country:
			Array.isArray(item.countries) && item.countries.length > 0
			  ? item.countries[0]?.name || ""
			  : "",
		};
	  })
	  .filter(Boolean);
  };
  
const generateOrgs = (data, refMap, idType) => {
  return data
    .map((item) => {
      // Ensure item.id exists and is valid
      const hasValidId = item && item.id !== undefined && item.id !== null;
      if (!hasValidId) {
        return null;
      }

      // Determine the reference value for item.id
      let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
      if (!idType) {
        refValue = item.id; // Use item.id if idType is false
      }

      // If idType is true but no reference exists in refMap, skip this item
      if (idType && (!refMap || !refMap[item.id])) {
        return null;
      }

      // Process parents if they exist
      if (item.parents && item.parents.length) {
        return item.parents
          .map((parent) => ({
            id: refValue,
            name: item.name,
            description: item.description,
            parent: parent.name,
            external: item.external,
          }))
          .filter(Boolean);
      } else {
        return {
          id: refValue,
          name: item.name,
          description: item.description,
          parent: "",
          external: item.external,
        };
      }
    })
    .filter(Boolean)
    .flat();
};

const generateOrgSite = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null; // Skip this item if it doesn't have a valid ID
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		// If idType is true but no reference exists in refMap, skip this item
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		// Process sites if they exist
		if (item.site && item.site.length) {
		  return item.site
			.map((site) => ({
			  organisation: item.name,
			  site: site.name,
			}))
			.filter(Boolean);
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateAppCap = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null; // Skip this item if it doesn't have a valid ID
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		// If idType is true but no reference exists in refMap, skip this item
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		const caps = [];
  
		// Process SupportedBusCapability
		if (item.SupportedBusCapability && item.SupportedBusCapability.length) {
		  caps.push(
			...item.SupportedBusCapability.map((supportedCap) => ({
			  id: refValue,
			  name: item.name,
			  description: supportedCap.description,
			  appCategory: item.appCapCategory,
			  busdom: "",
			  parentAppCat: "",
			  supportedCap: supportedCap.name,
			  refLayer: item.ReferenceModelLayer,
			}))
		  );
		}
  
		// Process businessDomain
		if (item.businessDomain && item.businessDomain.length) {
		  caps.push(
			...item.businessDomain.map((domain) => ({
			  id: refValue,
			  name: item.name,
			  description: item.description,
			  appCategory: item.appCapCategory,
			  busdom: domain.name,
			  parentAppCat: "",
			  supportedCap: "",
			  refLayer: item.ReferenceModelLayer,
			}))
		  );
		}
  
		// Process ParentAppCapability
		if (item.ParentAppCapability && item.ParentAppCapability.length) {
		  caps.push(
			...item.ParentAppCapability.map((parentAppCap) => ({
			  id: refValue,
			  name: item.name,
			  description: parentAppCap.description,
			  appCategory: item.appCapCategory,
			  busdom: "",
			  parentAppCat: parentAppCap.name,
			  supportedCap: "",
			  refLayer: item.ReferenceModelLayer,
			}))
		  );
		}
  
		// If no capabilities or domains exist, push default item
		if (
		  !item.ParentAppCapability &&
		  !item.SupportedBusCapability &&
		  !item.businessDomain
		) {
		  caps.push({
			id: refValue,
			name: item.name,
			description: item.description,
			appCategory: item.appCapCategory,
			busdom: "",
			parentAppCat: "",
			supportedCap: "",
			refLayer: item.ReferenceModelLayer,
		  });
		}
  
		return caps;
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateAppSvc = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		// If idType is true but no reference exists in refMap, skip this item
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		return {
		  id: refValue,
		  name: item.name,
		  description: item.description,
		};
	  })
	  .filter(Boolean);
  };
  
  const generateApp2Svc = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		// Process services if they exist
		if (item.services && item.services.length) {
		  return item.services.map((service) => ({
			app: item.name,
			service: service.name,
		  }));
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  const generateAppCapSvc = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		// Process services if they exist
		if (item.services && item.services.length) {
		  return item.services.map((service) => ({
			capability: item.name,
			service: service.name,
		  }));
		}
	  })
	  .filter(Boolean)
	  .flat();
  };

  const generateApps = (data, refMap, idType) => {
	return data.map((item) => {
	  // Ensure item.id exists and is valid
	  const hasValidId = item && item.id !== undefined && item.id !== null;
	  if (!hasValidId) {
		return null;
	  }
  
	  // Determine the reference value for item.id
	  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
	  if (!idType) {
		refValue = item.id; // Use item.id if idType is false
	  }
  
	  if (idType && (!refMap || !refMap[item.id])) {
		return null;
	  }
  
	  return {
		id: refValue,
		name: item.name,
		description: item.description,
		codebase_name: item.codebase_name,
		lifecycle_name: item.lifecycle_name,
		delivery_name: item.delivery_name,
	  };
	}).filter(Boolean);
  };

const generateBp2AppSvc = (data, refMap, idType) => {
  return data
    .map((item) => {
      // Ensure item.id exists and is valid
      const hasValidId = item && item.id !== undefined && item.id !== null;
      if (!hasValidId) {
        return null;
      }

      // Determine the reference value for item.id
      let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
      if (!idType) {
        refValue = item.id; // Use item.id if idType is false
      }

      if (idType && (!refMap || !refMap[item.id])) {
        return null;
      }

      // Process services if they exist
      if (item.services && item.services.length) {
        return item.services.map((service) => ({
          BusinessProcess: item.name,
          ApplicationService: service.name,
          Criticality: item.criticality,
        }));
      }
    })
    .filter(Boolean)
    .flat();
};

const generatePp2AppViaSvc = (data, refMap, idType) => {
  return data
    .map((item) => {
      // Ensure item.id exists and is valid
      const hasValidId = item && item.id !== undefined && item.id !== null;
      if (!hasValidId) {
        return null;
      }

      // Determine the reference value for item.id
      let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
      if (!idType) {
        refValue = item.id; // Use item.id if idType is false
      }

      if (idType && (!refMap || !refMap[item.id])) {
        return null;
      }

      if (item.appsviaservice && item.appsviaservice.length) {
        return item.appsviaservice.map((app) => ({
          Process: item.processName,
          org: item.org,
          appAndService: app.name,
        }));
      }
    })
    .filter(Boolean)
    .flat();
};

const generatePp2App = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.appsdirect && item.appsdirect.length) {
		  return item.appsdirect.map((app) => ({
			Process: item.processName,
			Org: item.org,
			Application: app.name,
		  }));
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  const generateApp2Org = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.actors && item.actors.length) {
		  return item.actors.map((actor) => ({
			app: item.name,
			org: actor.name,
		  }));
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateInfoReps = (data, refMap, idType) => {
	return data.map((item) => {
	  // Ensure item.id exists and is valid
	  const hasValidId = item && item.id !== undefined && item.id !== null;
	  if (!hasValidId) {
		return null;
	  }
  
	  // Determine the reference value for item.id
	  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
	  if (!idType) {
		refValue = item.id; // Use item.id if idType is false
	  }
  
	  if (idType && (!refMap || !refMap[item.id])) {
		return null;
	  }
  
	  return {
		id: refValue,
		name: item.name,
		description: item.description,
	  };
	}).filter(Boolean);
  };
  
  const generateServers = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.ipAddresses && item.ipAddresses.length) {
		  return item.ipAddresses.map((ip) => ({
			id: refValue,
			name: item.name,
			hosted: item.hostedIn,
			ip: ip,
		  }));
		} else {
		  return {
			id: refValue,
			name: item.name,
			hosted: item.hostedIn,
			ip: item.ipAddress,
		  };
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateApp2Server = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.deployment && item.deployment.length) {
		  return item.deployment.map((deployment) => ({
			app: item.name,
			servers: item.server,
			env: deployment.name,
		  }));
		} else {
		  return {
			app: item.name,
			servers: item.server,
			env: "",
		  };
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateTechDoms = (data, refMap, idType) => {
	return data.map((item) => {
	  // Ensure item.id exists and is valid
	  const hasValidId = item && item.id !== undefined && item.id !== null;
	  if (!hasValidId) {
		return null;
	  }
  
	  // Determine the reference value for item.id
	  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
	  if (!idType) {
		refValue = item.id; // Use item.id if idType is false
	  }
  
	  if (idType && (!refMap || !refMap[item.id])) {
		return null;
	  }
  
	  return {
		id: refValue,
		name: item.name,
		description: item.description,
		position: item.ReferenceModelLayer,
	  };
	}).filter(Boolean);
  };
  
  const generateTechCaps = (data, refMap, idType) => {
	return data.map((item) => {
	  // Ensure item.id exists and is valid
	  const hasValidId = item && item.id !== undefined && item.id !== null;
	  if (!hasValidId) {
		return null;
	  }
  
	  // Determine the reference value for item.id
	  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
	  if (!idType) {
		refValue = item.id; // Use item.id if idType is false
	  }
  
	  if (idType && (!refMap || !refMap[item.id])) {
		return null;
	  }
  
	  return {
		id: refValue,
		name: item.name,
		description: item.description,
		domain: item.domain,
	  };
	}).filter(Boolean);
  };
  
  const generateTechComps = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.caps && item.caps.length) {
		  return item.caps.map((cap) => ({
			id: refValue,
			name: item.name,
			description: item.description,
			parentCap: cap,
		  }));
		} else {
		  return {
			id: refValue,
			name: item.name,
			description: item.description,
			parentCap: "",
		  };
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateTechProds = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.usages && item.usages.length) {
		  return item.usages.map((usage) => ({
			id: refValue,
			name: item.name,
			supplier: item.supplier,
			description: item.description,
			family: item.family && item.family.length ? item.family[0].name : "",
			releaseStatus: item.lifecycle,
			delivery: item.delivery,
			usage: usage.name,
			compliance: usage.compliance,
			adoption: usage.adoption,
		  }));
		} else {
		  return {
			id: refValue,
			name: item.name,
			supplier: item.supplier,
			description: item.description,
			family: item.family && item.family.length ? item.family[0].name : "",
			releaseStatus: item.lifecycle,
			delivery: item.delivery,
			usage: "",
			compliance: "",
			adoption: "",
		  };
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateTechSuppliers = (data, refMap, idType) => {
	return data.map((item) => {
	  // Ensure item.id exists and is valid
	  const hasValidId = item && item.id !== undefined && item.id !== null;
	  if (!hasValidId) {
		return null;
	  }
  
	  // Determine the reference value for item.id
	  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
	  if (!idType) {
		refValue = item.id; // Use item.id if idType is false
	  }
  
	  if (idType && (!refMap || !refMap[item.id])) {
		return null;
	  }
  
	  return {
		id: refValue,
		name: item.name,
		description: item.description,
	  };
	}).filter(Boolean);
  };
  
  const generateTechProdFamily = (data, refMap, idType) => {
	return data.map((item) => {
	  // Ensure item.id exists and is valid
	  const hasValidId = item && item.id !== undefined && item.id !== null;
	  if (!hasValidId) {
		return null;
	  }
  
	  // Determine the reference value for item.id
	  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
	  if (!idType) {
		refValue = item.id; // Use item.id if idType is false
	  }
  
	  if (idType && (!refMap || !refMap[item.id])) {
		return null;
	  }
  
	  return {
		id: refValue,
		name: item.name,
		description: item.description,
	  };
	}).filter(Boolean);
  };
  const generateTechProdOrg = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.org && item.org.length) {
		  return item.org.map((org) => ({
			products: item.name,
			orgs: org.name,
		  }));
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateDataSubject = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.synonyms && item.synonyms.length) {
		  return item.synonyms.map((synonym) => ({
			id: refValue,
			name: item.name,
			description: item.description,
			synonym1: synonym.name,
			synonym2: "",
			category: item.category,
			orgOwner: item.orgOwner,
			indOwner: item.indivOwner,
		  }));
		} else {
		  return {
			id: refValue,
			name: item.name,
			description: item.description,
			synonym1: "",
			synonym2: "",
			category: item.category,
			orgOwner: item.orgOwner,
			indOwner: item.indivOwner,
		  };
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateDataObjectAttribute = (data, refMap, idType) => {
	return data
	  .map((item) => {
		return item.attributes
		  .map((attribute) => {
			// Ensure attribute.id exists and is valid
			const hasValidId = attribute && attribute.id !== undefined && attribute.id !== null;
			if (!hasValidId) {
			  return null;
			}
  
			// Determine the reference value for attribute.id
			let refValue = refMap && refMap[attribute.id] ? refMap[attribute.id].name : attribute.id;
			if (!idType) {
			  refValue = attribute.id; // Use attribute.id if idType is false
			}
  
			if (idType && (!refMap || !refMap[attribute.id])) {
			  return null;
			}
  
			if (attribute.synonyms && attribute.synonyms.length) {
			  return attribute.synonyms.map((synonym) => ({
				id: refValue,
				doName: item.name,
				attName: attribute.name,
				description: attribute.description,
				synonym1: synonym.name,
				synonym2: "",
				doTypeObj: attribute.typeObject,
				doTypePrim: attribute.typePrimitive,
				cardinality: attribute.cardinality,
			  }));
			} else {
			  return {
				id: refValue,
				doName: item.name,
				attName: attribute.name,
				description: attribute.description,
				synonym1: "",
				synonym2: "",
				doTypeObj: attribute.typeObject,
				doTypePrim: attribute.typePrimitive,
				cardinality: attribute.cardinality,
			  };
			}
		  })
		  .filter(Boolean)
		  .flat();
	  })
	  .flat();
  };
  
  const generateDataObjectInherit = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.id !== undefined && item.id !== null;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id
		let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
		if (!idType) {
		  refValue = item.id; // Use item.id if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.id])) {
		  return null;
		}
  
		if (item.children && item.children.length) {
		  return item.children.map((child) => ({
			parent: item.name,
			child: child.name,
		  }));
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
  const generateDataObject = (data, refMap, idType) => {
	const result = [];
	data.forEach((item) => {
	  // Ensure item.id exists and is valid
	  const hasValidId = item && item.id !== undefined && item.id !== null;
	  if (!hasValidId) {
		return null;
	  }
  
	  // Determine the reference value for item.id
	  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
	  if (!idType) {
		refValue = item.id; // Use item.id if idType is false
	  }
  
	  if (idType && (!refMap || !refMap[item.id])) {
		return null;
	  }
  
	  if (item.synonyms && item.synonyms.length) {
		item.synonyms.forEach((synonym) => {
		  result.push({
			id: refValue,
			name: item.name,
			description: item.description,
			synonym1: synonym.name,
			synonym2: "",
			parentDataSubj: "",
			dataCategory: item.category,
			abstract: item.isAbstract,
		  });
		});
	  }
	  if (item.parents && item.parents.length) {
		item.parents.forEach((parent) => {
		  result.push({
			id: refValue,
			name: item.name,
			description: item.description,
			synonym1: "",
			synonym2: "",
			parentDataSubj: parent.name,
			dataCategory: item.category,
			abstract: item.isAbstract,
		  });
		});
	  } else {
		result.push({
		  id: refValue,
		  name: item.name,
		  description: item.description,
		  synonym1: "",
		  synonym2: "",
		  parentDataSubj: "",
		  dataCategory: item.category,
		  abstract: item.isAbstract,
		});
	  }
	});
	return result.filter(Boolean);
  };
  
  const generateAppDependency = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.source && item.target;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.id (source and target can have IDs)
		let sourceRef = refMap && refMap[item.source] ? refMap[item.source].name : item.source;
		let targetRef = refMap && refMap[item.target] ? refMap[item.target].name : item.target;
		if (!idType) {
		  sourceRef = item.source; // Use item.source if idType is false
		  targetRef = item.target; // Use item.target if idType is false
		}
  
		if (idType && ((!refMap || !refMap[item.source]) || (!refMap || !refMap[item.target]))) {
		  return null;
		}
  
		if (item.info && item.info.length) {
		  return item.info.map((infoItem) => ({
			source: sourceRef,
			target: targetRef,
			info: infoItem.name,
			acquisition: item.acquisition,
			frequency:
			  Array.isArray(item.frequency) && item.frequency.length > 0
				? item.frequency[0]?.name || ""
				: "",
		  }));
		} else {
		  return {
			source: sourceRef,
			target: targetRef,
			info: "",
			acquisition: item.acquisition,
			frequency:
			  Array.isArray(item.frequency) && item.frequency.length > 0
				? item.frequency[0]?.name || ""
				: "",
		  };
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  const generateAppToTechProd = (data, refMap, idType) => {
	return data
	  .map((item) => {
		// Ensure item.id exists and is valid
		const hasValidId = item && item.application;
		if (!hasValidId) {
		  return null;
		}
  
		// Determine the reference value for item.application
		let refValue = refMap && refMap[item.application] ? refMap[item.application].name : item.application;
		if (!idType) {
		  refValue = item.application; // Use item.application if idType is false
		}
  
		if (idType && (!refMap || !refMap[item.application])) {
		  return null;
		}
  
		if (item.supportingTech && item.supportingTech.length) {
		  return item.supportingTech
			.filter((supportTech) => Object.keys(supportTech).length > 0)
			.map((supportTech) => ({
			  application: refValue,
			  environment: supportTech.environmentName,
			  fromTechProd: supportTech.fromTechProduct,
			  fromTechComp: supportTech.fromTechComponent,
			  toTechProd: supportTech.toTechProduct,
			  toTechComp: supportTech.toTechComponent,
			}));
		}
	  })
	  .filter(Boolean)
	  .flat();
  };
  
const generateStandardTemplate = (data) => {
  return data.map((item, index, arr) => ({
    id: item.id,
    name: item.name,
    description: item.description,
  }));
};

const generateStandardTemplateInternalId = (data, refMap, idType) => {
	 
	return data.map((item) => {
	  // Determine the reference value based on refMap and idType
	  let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
	  
	  if (!plusIdType) {
		refValue = item.id; // Use item.id if idType is false
	  }
  
	  if (plusIdType && (!refMap || !refMap[item.id])) {
		return null; // Return null if idType is true and refMap doesn't have the item
	  }
  
	  return {
		id: refValue,
		name: item.name,
		description: item.description,
	  };
	}).filter(item => item !== null); // Filter out any null values
  };
  


$("document").ready(function () {
	$("#busCapsWorksheetCheck").on("change", function () {
		return promise_loadViewerAPIData(viewAPIDataBusCaps)
		  .then(function (response1) {
		
			  // Filter out any sheet with id "busCapsWorksheetCheck" before pushing again
			  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "busCapsWorksheetCheck");
			  const jsonData = generateStructure(response1.businessCapabilities, refMap, idType);
	
			  $("#bc").css("border-left", "25px solid #0aa20a");
			  $("#busDomi").css("color", "red");
			  dataRows.sheets.push({
				id: "busCapsWorksheetCheck",
				name: "Business Capabilities",
				description:
				  "Used to capture the business capabilities of your organisation.  Some columns are also required to set up the view layout",
				notes:
				  "Set your root capability to be a single capability which your level 1 capabilities are tied to.  For that root capability only, duplicate the name of the capability in this column",
				headerRow: 7,
				headers: [
				  { name: "", width: 20 },
				  { name: "ID", width: 20 },
				  { name: "Name", width: 40 },
				  { name: "Description", width: 60 },
				  { name: "Parent Business Capability", width: 40 },
				  { name: "Position in Parent", width: 20 },
				  { name: "Sequence Number", width: 10 },
				  { name: "Root Capability", width: 30 },
				  { name: "Business Domain", width: 30 },
				  { name: "Level", width: 10 },
				],
				data: jsonData,
				lookup: [
				  {
					column: "E",
					values: "C",
					start: 8,
					end: 2011,
					worksheet: "Business Capabilities",
				  },
				  {
					column: "I",
					values: "C",
					start: 8,
					end: 100,
					worksheet: "Business Domains",
				  },
				  {
					column: "F",
					values: "C",
					start: 8,
					end: 100,
					worksheet: "Position Lookup",
				  },
				],
			  });
	
			  let jsonDataPositionLookup = generateStandardTemplate(busCapPosition);
	
			  // Filter out any sheet with id "posLookup" before pushing again
			  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "posLookup");
	
			  dataRows.sheets.push({
				id: "posLookup",
				name: "Position Lookup",
				description:
				  "Reference List of Positions for Bus Capabilities Model",
				notes: "",
				headerRow: 7,
				visible: false,
				headers: [
				  { name: "", width: 20 },
				  { name: "ID", width: 20 },
				  { name: "Name", width: 40 },
				  { name: "Description", width: 60 },
				],
				data: jsonDataPositionLookup,
				lookup: [],
			  });
			  //console.log('dr',dataRows)
			if (switchedOn.includes("busCap")) {
			//do nothing
			} else { 
			  switchedOn.push("busCap", "posLookup");
			}
		  }) 
	  });
	

  $("#busDomWorksheetCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataBusDoms)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#bd").css("border-left", "25px solid #0aa20a");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "busDomWorksheetCheck");
 
          //console.log("response1.businessDomains", response1.businessDomains);
          let jsonData = generateDomTable(response1.businessDomains, refMap, idType);
          //let jsonData=busdomtableTemplate(response1.businessDomains)
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "busDomWorksheetCheck",
            name: "Business Domains",
            description: "Used to capture the Business Domains in scope",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
              { name: "Parent Business Domain", width: 40 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Business Domains",
              },
            ],
          });
          //console.log('dr',dataRows)
		if (switchedOn.includes("busDom")) {
			//do nothing
		  } else {
          switchedOn.push("busDom");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#busProcsWorksheetCheck").on("change", function () {
    $("#busDomi").show();
    return promise_loadViewerAPIData(viewAPIDataBusProcs)
      .then(function (response1) {
		dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "busProcsWorksheetCheck");
 
          //console.log("response1", response1.businessProcesses);
          $("#bp").css("border-left", "25px solid #0aa20a");
          $("#busCapsi").css("color", "red");

          const jsonData = generateProcessTable(response1.businessProcesses, refMap, idType);

          console.log('proc jsonData',jsonData)
          dataRows.sheets.push({
            id: "busProcsWorksheetCheck",
            name: "Business Processes",
            description:
              "Captures the Business processes and their relationship to the business capabilities. For multiple parents, duplicate the row and add each parent",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
              { name: "Parent Capability", width: 40 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Business Capabilities",
              },
            ],
          });
		  if (switchedOn.includes("busProc")) {
			//do nothing
		  } else {
          switchedOn.push("busProc");
        }
      })
       
  });

  $("#busProcsFamilyWorksheetCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataBusProcFams)
      .then(function (response1) {
       
         // console.log("response1", response1);
          $("#bpf").css("border-left", "25px solid #0aa20a");
          $("#busProcsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "busProcsFamilyWorksheetCheck");
          let jsonData = generateProcessFamilyTable(response1.businessProcessFamilies, refMap, idType);

          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "busProcsFamilyWorksheetCheck",
            name: "Business Process Families",
            description:
              "Used to group Business Processes into their Family groupings, create duplicate rows for mapping multiple processes, just amend the process name",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Family Name", width: 40 },
              { name: "Description", width: 60 },
              { name: "Contained Business Processes", width: 40 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Business Processes",
              },
            ],
          });
          //console.log('dr',dataRows)
		if (switchedOn.includes("busProcFam")) {
			//do nothing
		  } else {
          switchedOn.push("busProcFam");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#sitesCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataSites)
      .then(function (response1) {
        
         // console.log("response1", response1);
          $("#st").css("border-left", "25px solid #0aa20a");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "Sites");
          const jsonData = generateSites(response1.sites, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "sitesCheck",
            name: "Sites",
            description:
              "Used to capture a list of Sites, including the country in which the Site exists",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
              { name: "Country", width: 40 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Countries",
              },
            ],
          });
          let jsonCtryData = generateSites(response1.countries, refMap, idType);

          dataRows.sheets.push({
            id: "country",
            name: "Countries",
            description: "List of Countries for sites select list",
            headerRow: 7,
            visible: "false",
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
            ],
            data: jsonCtryData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		if (switchedOn.includes("site")) {
			//do nothing
		  } else {
          switchedOn.push("site");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#orgsCheck, #orgs2sitesCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataOrgs)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#or").css("border-left", "25px solid #0aa20a");
          $("#ors").css("border-left", "25px solid #0aa20a");
          $("#sitesi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "orgsCheck");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "trueFalseLookup");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "org2site");
		  
          const jsonData = generateOrgs(response1.organisations, refMap, idType);

          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "orgsCheck",
            name: "Organisations",
            description: "Capture the organisations and hierarchy/structure",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
              { name: "Parent Organisation", width: 40 },
              { name: "external", width: 20 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Organisations",
              },
              {
                column: "F",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "True False Lookup",
              },
            ],
          });

          dataRows.sheets.push({
            id: "trueFalseLookup",
            name: "True False Lookup",
            description: "True, False",
            notes: "",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "id", width: 20 },
              { name: "Name", width: 40 },
            ],
            data: [
              { id: "true", name: "true" },
              { id: "false", name: "false" },
            ],
            lookup: [],
          });

          const jsonOrgSiteData = generateOrgSite(response1.organisations, refMap, idType);

          dataRows.sheets.push({
            id: "org2site",
            name: "Organisation to Sites",
            description: "Map which organisations use which sites",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Organisation", width: 20 },
              { name: "Site", width: 40 },
            ],
            data: jsonOrgSiteData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Organisations",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Sites",
              },
            ],
          });

          //console.log('dr',dataRows)
		if (switchedOn.includes("orgs")) {
			//do nothing
		  } else {
          switchedOn.push("orgs");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#appCapsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataAppCaps)
      .then(function (response1) {
      
          //console.log('response1',response1)
          $("#ac").css("border-left", "25px solid #0aa20a");
          $("#busDomi").css("color", "red");
          $("#busCapsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "appCapsCheck");
          const jsonData = generateAppCap(response1.application_capabilities, refMap, idType);

          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "appCapsCheck",
            name: "Application Capabilities",
            description:
              "Captures the Application Capabilities required to support the business and the category to manage the structure of the view",
            notes:
              "Ignore the duplicate rows, this is due to the need to extract complex relationships, the import will import normally",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
              { name: "App Cap Category", width: 40 },
              { name: "Business Domain", width: 40 },
              { name: "Parent Cap Capability", width: 40 },
              { name: "Supported Bus Capability", width: 40 },
              { name: "Reference Model Layer", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "F",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Business Domains",
              },
              {
                column: "G",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "AppCap Lookup",
              },
              {
                column: "H",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Business Capabilities",
              },
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "AppCatLookup",
              },
              {
                column: "I",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "AppRefLookup",
              },
            ],
          });

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "appcapLookup");
          let jsonDataAppCapLookup = generateStandardTemplate(response1.application_capabilities);
          dataRows.sheets.push({
            id: "appcapLookup",
            name: "AppCap Lookup",
            description: "Reference List of Application Capabilities",
            notes: "",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
            ],
            data: jsonDataAppCapLookup,
            lookup: [],
          });
          let jsonDataAppCatLookup = generateStandardTemplate(appCategory);
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "appcatLookup");
          dataRows.sheets.push({
            id: "appcatLookup",
            name: "AppCatLookup",
            description: "Reference List of Application Capability Categories",
            notes: "",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
            ],
            data: jsonDataAppCatLookup,
            lookup: [],
          });
          let jsonDataAppRefLookup = generateStandardTemplate(appRefModelLayer);
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "apprefLookup");
          dataRows.sheets.push({
            id: "apprefLookup",
            name: "AppRefLookup",
            description:
              "Reference List of Application Capability Reference model positions",
            notes: "",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
            ],
            data: jsonDataAppRefLookup,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("appCap")) {
			//do nothing
		  } else {
			switchedOn.push("appCap");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#appSvcsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataAppSvcs)
      .then(function (response1) {
       
        //  console.log("response1", response1);
          $("#as").css("border-left", "25px solid #0aa20a");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "appSvcsCheck");
          const jsonData = generateAppSvc(response1.application_services, refMap, idType);
         // console.log("jsonData", jsonData);
          dataRows.sheets.push({
            id: "appSvcsCheck",
            name: "Application Services",
            description:
              "Capture the Application Services required to support the business",
            headerRow: 7,
            visible: true,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
              { name: "Description", width: 60 },
            ],
            data: jsonData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("appSvcs")) {
			//do nothing
		  } else {
			switchedOn.push("appSvcs");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });
  $("#appCaps2SvcsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataAppCap2Svcs)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#ac2s").css("border-left", "25px solid #0aa20a");
          $("#appCapsi").css("color", "red");
          $("#appSvcsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "appCaps2SvcsCheck");
          const jsonData = generateAppCapSvc( response1.application_capabilities_services, refMap, idType);

          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "appCaps2SvcsCheck",
            name: "App Service 2 App Capabilities",
            description:
              "Capture the mapping of the Application Services to the Application Capability they support",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Application Capability", width: 30 },
              { name: "Application Service", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "AppCap Lookup",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Application Services",
              },
            ],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("appSvs2AC")) {
			//do nothing
		  } else {
			switchedOn.push("appSvs2AC");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#appsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataApps)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#aps").css("border-left", "25px solid #0aa20a");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "appsCheck");
          const jsonData = generateApps(response1.applications, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "appsCheck",
            name: "Applications",
            description:
              "Captures information about the Applications used within the organisation",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
              { name: "Type", width: 30 },
              { name: "Lifecycle Status", width: 30 },
              { name: "Delivery Model", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "CodebaseLookup",
              },
              {
                column: "G",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "DeliveryLookup",
              },
              {
                column: "F",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "LifecycleLookup",
              },
            ],
          });

          let jsonCodebaseData = generateStandardTemplate(allCodebase);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "codebaseLookup");
          dataRows.sheets.push({
            id: "codebaseLookup",
            name: "CodebaseLookup",
            description: "List of codebases",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonCodebaseData,
            lookup: [],
          });
          let jsonDeliveryData = generateStandardTemplate(allDelivery);
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "delivlookup");
          dataRows.sheets.push({
            id: "delivlookup",
            name: "DeliveryLookup",
            description: "List of app delivery models",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonDeliveryData,
            lookup: [],
          });
          let jsonLifeData = generateStandardTemplate(allLifecycle);
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "lifelookup");
          dataRows.sheets.push({
            id: "lifelookup",
            name: "LifecycleLookup",
            description: "List of lifecycles",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonLifeData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("apps")) {
			//do nothing
		  } else {
			switchedOn.push("apps");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#apps2svcsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataApps2Svcs)
      .then(function (response1) {
      
          //console.log('response1',response1)
          $("#aps2sv").css("border-left", "25px solid #0aa20a");
          $("#appsi").css("color", "red");
          $("#appSvcsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "apps2svcsCheck");
          let jsonData = generateApp2Svc(response1.applications_to_services, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "apps2svcsCheck",
            name: "App Service 2 Apps",
            description:
              "Maps the Applications to the Services they can provide",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Application", width: 30 },
              { name: "Application Service", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Applications",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Application Services",
              },
            ],
            concatenate: {
              column: "D",
              type: "=CONCATENATE",
              formula: 'B, " as ", C',
            },
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("appServtApp")) {
			//do nothing
		  } else {
			 switchedOn.push("appServtApp");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#apps2orgsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataApps2orgs)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#aps2or").css("border-left", "25px solid #0aa20a");
          $("#appsi").css("color", "red");
          $("#orgsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "apps2orgsCheck");
          let jsonData = generateApp2Org(response1.applications_to_orgs, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "apps2orgsCheck",
            name: "Application to User Orgs",
            description:
              "Maps the Applications to the Organisations that use them",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Application", width: 30 },
              { name: "Organisation", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Applications",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Organisations",
              },
            ],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("app2org")) {
			//do nothing
		  } else {
			switchedOn.push("app2org");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });
  $("#busProc2SvcsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataBPtoAppsSvc)
      .then(function (response1) {
        
          //console.log('response1',response1)
          $("#bp2srvs").css("border-left", "25px solid #0aa20a");
          $("#busProcsi").css("color", "red");
          $("#appsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "busProc2SvcsCheck");
          let jsonData = generateBp2AppSvc(response1.process_to_service, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "busProc2SvcsCheck",
            name: "Business Process 2 App Services",
            description:
              "Maps the business processes to the application services they require",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Business Process", width: 30 },
              { name: "Application Service", width: 30 },
              { name: "Criticality of Application Service", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Business Processes",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Application Services",
              },
              {
                column: "D",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "CriticalityLookup",
              },
            ],
          });
          let jsonCriticalityData = generateStandardTemplate(allCriticality);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "criticalLookup");
          dataRows.sheets.push({
            id: "criticalLookup",
            name: "CriticalityLookup",
            description: "List of criticalities",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonCriticalityData,
            lookup: [],
          });
          //console.log('dr',dataRows)
          if (switchedOn.includes("proctoAppSv")) {
			//do nothing
		  } else {
			switchedOn.push("proctoAppSv");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#physProc2AppVsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataPPtoAppsViaSvc)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#phyp2appsv").css("border-left", "25px solid #0aa20a");
          $("#busProcsi").css("color", "red");
          $("#orgsi").css("color", "red");
          $("#apps2svcsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "physProc2AppVsCheck");
          let jsonData = generatePp2AppViaSvc(response1.process_to_apps, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "physProc2AppVsCheck",
            name: "Physical Proc 2 App and Service",
            description:
              "Maps the Process to the organisations that perform them, the applications used and what the application is used for (service)",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Business Process", width: 30 },
              { name: "Performing Organisation", width: 30 },
              { name: "Application and Service Used", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Business Processes",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Organisations",
              },
              {
                column: "D",
                values: "D",
                start: 8,
                end: 2011,
                worksheet: "App Service 2 Apps",
              },
            ],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("physProctoAS")) {
			//do nothing
		  } else {
			switchedOn.push("physProctoAS");
        }
      })
  });

  $("#physProc2AppCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataPPtoAppsViaSvc)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#phyp2appdirect").css("border-left", "25px solid #0aa20a");
          $("#busProcsi").css("color", "red");
          $("#orgsi").css("color", "red");
          $("#appsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "physProc2AppCheck");
          let jsonData = generatePp2App(response1.process_to_apps, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "physProc2AppCheck",
            name: "Physical Proc 2 App",
            description:
              "Maps the Process to the Organisations that perform them and the applications used.",
            notes:
              "Only use this sheet if you don't know the services the apps are providing",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Business Process", width: 30 },
              { name: "Performing Organisation", width: 30 },
              { name: "Applications", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Business Processes",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Organisations",
              },
              {
                column: "D",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Applications",
              },
            ],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("physproc2app")) {
			//do nothing
		  } else {
			switchedOn.push("physproc2app");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#infoExchangedCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataInfoRep)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#infex").css("border-left", "25px solid #0aa20a");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "infoExchangedCheck");
          let jsonData = generateInfoReps(response1.infoReps, refMap, idType);
          //console.log(' inf ex jsonData',jsonData)
          dataRows.sheets.push({
            id: "infoExchangedCheck",
            name: "Information Exchanged",
            description:
              "Used to capture the Information exchanged between applications",
            notes: "",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 30 },
            ],
            data: jsonData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("infoex")) {
			//do nothing
		  } else {
			 switchedOn.push("infoex");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#nodesCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataNodes)
      .then(function (response1) {
      
          //console.log('response1',response1)
          $("#nodes").css("border-left", "25px solid #0aa20a");
          $("#sitesi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "nodesCheck");
          let jsonData = generateServers(response1.nodes, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "nodesCheck",
            name: "Servers",
            description:
              "Captures the list of physical technology nodes deployed across the enterprise, and the IP address if available",
            notes: "",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 30 },
              { name: "Name", width: 30 },
              { name: "Hosted In", width: 30 },
              { name: "IP Address", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "D",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Sites",
              },
            ],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("servers")) {
			//do nothing
		  } else {
			 switchedOn.push("servers");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#apps2serverCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataApptoServer)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#ap2servs").css("border-left", "25px solid #0aa20a");
          $("#nodesi").css("color", "red");
          $("#appsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "apps2serverCheck");
          let jsonData = generateApp2Server(response1.app2server, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "apps2serverCheck",
            name: "Application 2 Server",
            description:
              "Maps the applications to the servers that they are hosted on, with the environment",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Application", width: 30 },
              { name: "Server", width: 30 },
              { name: "Environment", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Applications",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Servers",
              },
              {
                column: "D",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "EnvironmentLookup",
              },
            ],
          });
          let jsonEnvironmentData = generateStandardTemplate(allEnvironment);
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "EnvironmentLookup");
          dataRows.sheets.push({
            name: "EnvironmentLookup",
            description: "List of codebases",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonEnvironmentData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("app2serv")) {
			//do nothing
		  } else {
			switchedOn.push("app2serv");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#techDomsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataTechDomains)
      .then(function (response1) {
      
          //console.log('response1',response1)
          $("#tds").css("border-left", "25px solid #0aa20a");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "techDomsCheck");
          let jsonData = generateTechDoms(response1.technology_domains, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "techDomsCheck",
            name: "Technology Domains",
            description: "Used to capture a list of Technology Domains",
            notes:
              "The positions place the top level domains in some TRM models",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 30 },
              { name: "Name", width: 30 },
              { name: "Description", width: 30 },
              { name: "Position", width: 20 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "TRMPosLookup",
              },
            ],
          });

          let jsonTRMLayerData = generateStandardTemplate(techRefModelLayer);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "trmlookup");
          dataRows.sheets.push({
            id: "trmlookup",
            name: "TRMPosLookup",
            description: "List of positions for TRM",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonTRMLayerData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("techdoms")) {
			//do nothing
		  } else {
			switchedOn.push("techdoms");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#techCapsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataTechCap)
      .then(function (response1) {
        
          //console.log('response1',response1)
          $("#tcaps").css("border-left", "25px solid #0aa20a");
          $("#techDomsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "techCapsCheck");
          let jsonData = generateTechCaps(response1.technology_capabilities, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "techCapsCheck",
            name: "Technology Capabilities",
            description: "Used to capture a list of Technology Capabilities",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 30 },
              { name: "Name", width: 30 },
              { name: "Description", width: 30 },
              { name: "Parent Technology Domain", width: 20 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Technology Domains",
              },
            ],
          });
          //console.log('dr',dataRows)
          if (switchedOn.includes("techcap")) {
			//do nothing
		  } else {
			switchedOn.push("techcap");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });
  $("#techCompsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataTechComp)
      .then(function (response1) {
        //console.log("tc response1", response1);
       
          //console.log('response1',response1)
          $("#tcomps").css("border-left", "25px solid #0aa20a");
          $("#techCapsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "techCompsCheck");
          let jsonData = generateTechComps(response1.technology_components, refMap, idType);

          dataRows.sheets.push({
            id: "techCompsCheck",
            name: "Technology Components",
            description: "Used to capture a list of Technology Components",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 30 },
              { name: "Name", width: 30 },
              { name: "Description", width: 30 },
              { name: "Parent Technology Capability", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Technology Capabilities",
              },
            ],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("techcomp")) {
			//do nothing
		  } else {
			switchedOn.push("techcomp");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#techProductsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataTechProd).then(function (response1) {
        //console.log('response1',response1)
        $("#tprods").css("border-left", "25px solid #0aa20a");
        $("#techSuppi").css("color", "red");
        $("#techFami").css("color", "red");
		dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "techProductsCheck");
        let jsonData = generateTechProds(response1.technology_products, refMap, idType);
        // console.log('tp jsonData',jsonData)
        dataRows.sheets.push({
          id: "techProductsCheck",
          name: "Technology Products",
          description: "Details the Technology Products",
          headerRow: 7,
          headers: [
            { name: "", width: 20 },
            { name: "ID", width: 30 },
            { name: "Name", width: 30 },
            { name: "Supplier", width: 30 },
            { name: "Description", width: 60 },
            { name: "Product Family", width: 30 },
            { name: "Vendor Release Status", width: 30 },
            { name: "Delivery Model", width: 30 },
            { name: "Usage", width: 30 },
            { name: "Usage Compliance Level", width: 30 },
            { name: "Usage Adoption Status", width: 30 },
          ],
          data: jsonData,
          lookup: [
            {
              column: "C",
              values: "C",
              start: 8,
              end: 2011,
              worksheet: "Technology Suppliers",
            },
            {
              column: "F",
              values: "C",
              start: 8,
              end: 2011,
              worksheet: "Technology Product Families",
            },
            {
              column: "I",
              values: "C",
              start: 8,
              end: 2011,
              worksheet: "Technology Components",
            },
            {
              column: "C",
              values: "C",
              start: 8,
              end: 2011,
              worksheet: "Technology Suppliers",
            },
            {
              column: "G",
              values: "C",
              start: 8,
              end: 2011,
              worksheet: "VendLifeLookup",
            },
            {
              column: "H",
              values: "C",
              start: 8,
              end: 2011,
              worksheet: "TechDeliveryLookup",
            },
            {
              column: "J",
              values: "C",
              start: 8,
              end: 2011,
              worksheet: "StdLookup",
            },
            {
              column: "K",
              values: "C",
              start: 8,
              end: 2011,
              worksheet: "LifecycleLookup2",
            },
          ],
        });
        let jsonVendLifeData = generateStandardTemplate(allTechLifecycle);
        //	console.log('tp jsonVendLifeData',jsonVendLifeData)
		dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "vendlookup");
        dataRows.sheets.push({
          id: "vendlookup",
          name: "VendLifeLookup",
          description: "List of vendor lifecycles",
          headerRow: 7,
          visible: false,
          headers: [
            { name: "", width: 20 },
            { name: "ID", width: 20 },
            { name: "Name", width: 30 },
            { name: "Description", width: 60 },
          ],
          data: jsonVendLifeData,
          lookup: [],
        });

        let jsonTechDelData = generateStandardTemplate(allTechDelivery);
        //		console.log('tp jsonTechDelData',jsonTechDelData)

		dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "techdelivLookup");
        dataRows.sheets.push({
          id: "techdelivLookup",
          name: "TechDeliveryLookup",
          description: "List of technology delivery status",
          headerRow: 7,
          visible: false,
          headers: [
            { name: "", width: 20 },
            { name: "ID", width: 20 },
            { name: "Name", width: 30 },
            { name: "Description", width: 60 },
          ],
          data: jsonTechDelData,
          lookup: [],
        });

        let jsonStdData = generateStandardTemplate(allStandardStrengths);
        //	console.log('tp jsonStdData',jsonStdData)
		dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "stdlookup");
        dataRows.sheets.push({
          id: "stdlookup",
          name: "StdLookup",
          description: "List of codebases",
          headerRow: 7,
          visible: false,
          headers: [
            { name: "", width: 20 },
            { name: "ID", width: 20 },
            { name: "Name", width: 30 },
            { name: "Description", width: 60 },
          ],
          data: jsonStdData,
          lookup: [],
        });
        let jsonLifeData = generateStandardTemplate(allLifecycle);
        //	console.log('tp jsonLifeData',jsonLifeData)

		dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "lifelookup2");
        dataRows.sheets.push({
          id: "lifelookup2",
          name: "LifecycleLookup2",
          description: "List of lifecycles",
          headerRow: 7,
          visible: false,
          headers: [
            { name: "", width: 20 },
            { name: "ID", width: 20 },
            { name: "Name", width: 30 },
            { name: "Description", width: 60 },
          ],
          data: jsonLifeData,
          lookup: [],
        });
        //console.log('dr',dataRows)
		if (switchedOn.includes("techprod")) {
			//do nothing
		  } else {
			switchedOn.push("techprod");
      }
    });
  });
  $("#techSuppliersCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataTechSupplier)
      .then(function (response1) {
      
          //console.log('response1',response1)
          $("#tsups").css("border-left", "25px solid #0aa20a");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "techSuppliersCheck");
          let jsonData = generateTechSuppliers(response1.technology_suppliers, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "techSuppliersCheck",
            name: "Technology Suppliers",
            description: "Used to capture a list of Technology Suppliers",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 30 },
              { name: "Name", width: 30 },
              { name: "Description", width: 30 },
            ],
            data: jsonData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("supp")) {
			//do nothing
		  } else {
			switchedOn.push("supp");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#techProductFamiliesCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataTechProdFamily)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#tprodfams").css("border-left", "25px solid #0aa20a");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "techProductFamiliesCheck");
          let jsonData = generateTechProdFamily(response1.technology_product_family, refMap, idType);
          // console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "techProductFamiliesCheck",
            name: "Technology Product Families",
            description:
              "Used to capture a list of Technology Product Families that group separate versions of a Technology Product into a family for that Product. e.g. Oracle WebLogic to group WebLogic 7.0, WebLogic 8.0, WebLogic 9.0",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 30 },
              { name: "Family Name", width: 30 },
              { name: "Description", width: 30 },
            ],
            data: jsonData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("tpf")) {
			//do nothing
		  } else {
			switchedOn.push("tpf");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#techProducttoOrgsCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataTechProdOrg)
      .then(function (response1) {
        
          //console.log('response1',response1)
          $("#tprodors").css("border-left", "25px solid #0aa20a");
          $("#techProdsi").css("color", "red");
          $("#orgsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "techProducttoOrgsCheck");
          let jsonData = generateTechProdOrg(response1.technology_product_orgs, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "techProducttoOrgsCheck",
            name: "Tech Prods to User Orgs",
            description:
              "Maps Technology Products to the Organisations that use them",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Technology Product", width: 30 },
              { name: "Organisation", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Technology Products",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Organisations",
              },
            ],
          });
          //console.log('dr',dataRows)
          if (switchedOn.includes("tptouser")) {
			//do nothing
		  } else {
			switchedOn.push("tptouser");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#dataSubjectCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataDataSubject)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#dsubjs").css("border-left", "25px solid #0aa20a");
          $("#orgsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "dataSubjectCheck");
          let jsonData = generateDataSubject(response1.data_subjects, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "dataSubjectCheck",
            name: "Data Subjects",
            description:
              "Captures the data subjects used within the organisation",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 30 },
              { name: "Synonym1", width: 30 },
              { name: "Synonym2", width: 30 },
              { name: "Data Category", width: 30 },
              { name: "Organisation Owner", width: 30 },
              { name: "Individual Owner", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "H",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Organisations",
              },
              {
                column: "I",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Individuals Lookup",
              },
              {
                column: "G",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "DataCatLookup",
              },
            ],
          });
          let jsonDataIndividualLookup =
            generateStandardTemplate(allIndividuals);
			dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "indivLookup");
          dataRows.sheets.push({
            id: "indivLookup",
            name: "Individuals Lookup",
            description: "Reference List of Individuals",
            notes: "",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 40 },
            ],
            data: jsonDataIndividualLookup,
            lookup: [],
          });
          //console.log('dr',dataRows)
          let jsonDataCatData = generateStandardTemplate(allDataCategory);
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "datacatLookup");
          dataRows.sheets.push({
            id: "datacatLookup",
            name: "DataCatLookup",
            description: "List of data categories",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonDataCatData,
            lookup: [],
          });
		  if (switchedOn.includes("datasubj")) {
			//do nothing
		  } else {
			switchedOn.push("datasubj");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });
  $("#dataObjectCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataDataObject)
      .then(function (response1) {
        
          // console.log('response1',response1)
          $("#dObjs").css("border-left", "25px solid #0aa20a");
          $("#dataSubjsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "dataObjectCheck");
          let jsonData = generateDataObject(response1.data_objects, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "dataObjectCheck",
            name: "Data Objects",
            description:
              "Captures the data objects used within the organisation",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 30 },
              { name: "Synonym1", width: 30 },
              { name: "Synonym2", width: 30 },
              { name: "Parent Data Subject", width: 30 },
              { name: "Data Category", width: 30 },
              { name: "Is Abstract", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "G",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Data Subjects",
              },
              {
                column: "H",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "DataCatLookup2",
              },
              {
                column: "I",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "isAbstractLookup",
              },
            ],
          });

          let jsonDataCatData = generateStandardTemplate(allDataCategory);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "datacat2");
          dataRows.sheets.push({
            id: "datacat2",
            name: "DataCatLookup2",
            description: "List of data categories",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonDataCatData,
            lookup: [],
          });
          let jsonAbstractData = generateStandardTemplate(isAbstract);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "abstract");
          dataRows.sheets.push({
            id: "abstract",
            name: "isAbstractLookup",
            description: "List of values",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonAbstractData,
            lookup: [],
          });
          // console.log('dr',dataRows)
          if (switchedOn.includes("dataobj")) {
			//do nothing
		  } else {
			switchedOn.push("dataobj");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#dataObjectInheritCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataDataObjectInherit)
      .then(function (response1) {
       
         // console.log("do response1", response1);
          $("#dObjins").css("border-left", "25px solid #0aa20a");
          $("#dataObjsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "dataObjectInheritCheck");
          let jsonData = generateDataObjectInherit(response1.data_object_inherit, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "dataObjectInheritCheck",
            name: "Data Object Inheritance",
            description:
              "Captures the relationships between parent and child objects",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Parent Data Object", width: 20 },
              { name: "Child Data Object", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Data Objects",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Data Objects",
              },
            ],
          });
          //console.log('dr',dataRows)
          if (switchedOn.includes("dataobjinherit")) {
			//do nothing
		  } else {
			 switchedOn.push("dataobjinherit");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });
  $("#dataObjectAttributeCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataDataObjectAttribute).then(
      function (response1) {
       
          //console.log('response1',response1)
          $("#dObjAts").css("border-left", "25px solid #0aa20a");
          $("#dataObjsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "dataObjectAttributeCheck");
          let jsonData = generateDataObjectAttribute(response1.data_object_attributes, refMap, idType);

          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "dataObjectAttributeCheck",
            name: "Data Attributes",
            description:
              "Captures the data object Attributes used within the organisation",
            notes: "One of these per row, not both in one row",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Data Object Name", width: 30 },
              { name: "Data Attribute Name", width: 30 },
              { name: "Description", width: 40 },
              { name: "Synonym1", width: 30 },
              { name: "Synonym2", width: 30 },
              { name: "Data Type (Object)", width: 30 },
              { name: "Data Type (Primitive)", width: 30 },
              { name: "Cardinality", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Data Objects",
              },
              {
                column: "H",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Data Objects",
              },
              {
                column: "I",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "PrimitiveLookup",
              },
              {
                column: "J",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "CardinalityLookup",
              },
            ],
          });

          let jsonCardData = generateStandardTemplate(allDataCardinaility);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "cardinality");
          dataRows.sheets.push({
            id: "cardinality",
            name: "CardinalityLookup",
            description: "List of cardinality",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonCardData,
            lookup: [],
          });
          let jsonPrimitivesData = generateStandardTemplate(allDataPrimitives);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "PrimitiveLookup");
          dataRows.sheets.push({
            name: "PrimitiveLookup",
            description: "List of data primitives",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonPrimitivesData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("dataattribs")) {
			//do nothing
		  } else {
			switchedOn.push("dataattribs");
        }
      }
    );
  });
  $("#appDependencyCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIDataAppDependency)
      .then(function (response1) {
      
          //console.log('response1',response1)
          applicationDependencies = response1;
          //filter out APIs
          applicationDependencies.application_dependencies =
            applicationDependencies.application_dependencies.filter((d) => {
              return d.sourceType !== "" && d.targetType !== "";
            });
          $("#appDps").css("border-left", "25px solid #0aa20a");
          $("#appsi").css("color", "red");
          $("#infoXi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "appDependencyCheck");
          let jsonData = generateAppDependency(applicationDependencies.application_dependencies, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "appDependencyCheck",
            name: "Application Dependencies",
            description:
              "Captures the information dependencies between applications; where information passes between applications and the method for passing the information",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Source Application", width: 30 },
              { name: "Target Application", width: 30 },
              { name: "Information Exchanged", width: 30 },
              { name: "Acquisition Method", width: 40 },
              { name: "Frequency", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Applications",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Applications",
              },
              {
                column: "D",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Information Exchanged",
              },
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "AcquisitionLookup",
              },
              {
                column: "F",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "TimelinessLookup",
              },
            ],
          });

          let jsontimelinessData = generateStandardTemplate(allTimeliness);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "time");
          dataRows.sheets.push({
            id: "time",
            name: "TimelinessLookup",
            description: "List of timeliness",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsontimelinessData,
            lookup: [],
          });
          let jsonAcqData = generateStandardTemplate(allAcqMeth);

		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "acquire");
          dataRows.sheets.push({
            id: "acquire",
            name: "AcquisitionLookup",
            description: "List of acquisition methods",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonAcqData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("appdeps")) {
			//do nothing
		  } else {
			switchedOn.push("appdeps");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });

  $("#apptotechCheck").on("change", function () {
    return promise_loadViewerAPIData(viewAPIPathApptoTech)
      .then(function (response1) {
       
          //console.log('response1',response1)
          $("#apptechs").css("border-left", "25px solid #0aa20a");

          $("#appsi").css("color", "red");
          $("#techCompsi").css("color", "red");
          $("#techProdsi").css("color", "red");
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "apptotechCheck");
          let jsonData = generateAppToTechProd( response1.application_technology_architecture, refMap, idType);
          //console.log('jsonData',jsonData)
          dataRows.sheets.push({
            id: "apptotechCheck",
            name: "App to Tech Products",
            description:
              "Defines the technology architecture supporting applications in terms of Technology Products, the components that they implement and the dependencies between them",
            notes: "One of these per row, not both in one row.  Use The Import Utility to import these",
            headerRow: 7,
            headers: [
              { name: "", width: 20 },
              { name: "Application", width: 30 },
              { name: "Environment", width: 30 },
              { name: "From Technology Product", width: 30 },
              { name: "From Technology Component", width: 30 },
              { name: "To Technology Product", width: 30 },
              { name: "To Technology Component", width: 30 },
            ],
            data: jsonData,
            lookup: [
              {
                column: "B",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Applications",
              },
              {
                column: "C",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "EnvironmentLookup2",
              },
              {
                column: "D",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Technology Products",
              },
              {
                column: "E",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Technology Components",
              },
              {
                column: "F",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Technology Products",
              },
              {
                column: "G",
                values: "C",
                start: 8,
                end: 2011,
                worksheet: "Technology Components",
              },
            ],
          });
          jsonEnvironmentData = generateStandardTemplate(allEnvironment);
		  dataRows.sheets = dataRows.sheets.filter(sheet => sheet.id !== "env2");
          dataRows.sheets.push({
            id: "env2",
            name: "EnvironmentLookup2",
            description: "List of codebases",
            headerRow: 7,
            visible: false,
            headers: [
              { name: "", width: 20 },
              { name: "ID", width: 20 },
              { name: "Name", width: 30 },
              { name: "Description", width: 60 },
            ],
            data: jsonEnvironmentData,
            lookup: [],
          });
          //console.log('dr',dataRows)
		  if (switchedOn.includes("atarch")) {
			//do nothing
		  } else {
			switchedOn.push("atarch");
        }
      })
      .catch(function (error) {
        console.error("Error:", error);
        alert("Error - " + error.message);
      });
  });
});
