/* script for creating plus sheets in launchpad */
const generateSQ = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: refValue,
                name: item.name,
                label: item.shortName,
                description: item.description,
                sequenceNo: item.serviceIndex,
                weighting: item.serviceWeighting,
            };
        })
        .filter(Boolean); // Filter out null or empty values
};
const generatePMCs = (data, refMap, plusIdType) => {
    return data
        .flatMap((parent) => {
            // Ensure parent.id exists and is valid
            const hasValidId = parent && parent.id !== undefined && parent.id !== null;
            if (!hasValidId || !Array.isArray(parent.classes)) {
                return [];
            }

            // Iterate over each class in the 'enumeration_value_for_classes' array
            return parent.classes.flatMap((cls) => {
                // Ensure the class is valid (cls is a string)
                const hasValidClass = cls && typeof cls === "string";
                if (!hasValidClass) {
                    return [];
                }

                // Determine the reference value for parent.id
                let refValue = refMap && refMap[parent.id] ? refMap[parent.id].name : parent.id;
                if (!plusIdType) {
                    refValue = parent.id; // Use parent.id if plusIdType is false
                }

                // If idType is true but no reference exists in refMap, skip this class
                if (plusIdType && (!refMap || !refMap[parent.id])) {
                    return [];
                }

                return {
                    id: refValue,
                    parentName: parent.name, // Set the parent name
                    label: parent.enumeration_value,
                    description: parent.description,
                    sequenceNo: parent.enumeration_sequence_number,
                    className: cls, // Use cls as the class name (string)
                };
            });
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateSQVs = (data, refMap, plusIdType) => {
    return data
        .flatMap((parent) => {
            // Ensure parent.name exists
            const hasValidName = parent && parent.name;
            if (!hasValidName || !Array.isArray(parent.sqvs)) {
                return [];
            }

            // Iterate over each SQV in the list
            return parent.sqvs.flatMap((sqv) => {
                // Ensure SQV is valid
                const hasValidId = sqv && sqv.id !== undefined && sqv.id !== null;
                if (!hasValidId) {
                    return [];
                }

                // Determine the reference value for sqv.id
                let refValue = refMap && refMap[sqv.id] ? refMap[sqv.id].name : sqv.id;
                if (!plusIdType) {
                    refValue = sqv.id; // Use sqv.id if plusIdType is false
                }

                // If idType is true but no reference exists in refMap, skip this SQV
                if (plusIdType && (!refMap || !refMap[sqv.id])) {
                    return [];
                }

                return {
                    id: refValue,
                    parentName: parent.name, // Set the parent name
                    value: sqv.value,
                    description: sqv.description || "", // Handle empty descriptions
                    sequenceNo: sqv.index || "", // Handle missing indexes
                    colour: sqv.elementBackgroundColour || "#ffffff", // Fallback for missing colours
                    style: "",
                    score: sqv.score || "", // Handle missing scores
                    nmTranslate: "",
                    nmDescription: "",
                    language: ""
                };
            });
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateStratPlans = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            // If roadmap is an array, create a row for each roadmap
            if (Array.isArray(item.roadmaps)) {
                return item.roadmaps.map((roadmap) => ({
                    id: refValue,
                    roadmap: roadmap,
                    name: item.name,
                    description: item.description,
                    startDate: item.validStartDate ?? "",
                    endDate: item.validEndDate ?? "",
                }));
            } else {
                // Otherwise, create a single row with the given roadmap
                return {
                    id: refValue,
                    roadmap: item.roadmap ?? "",
                    name: item.name,
                    description: item.description,
                    startDate: item.validStartDate ?? "",
                    endDate: item.validEndDate ?? "",
                };
            }
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateStratPlansObj = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            // If roadmap is an array, create a row for each roadmap
            if (Array.isArray(item.objectives)) {
                return item.objectives.map((obj) => ({
                    name: item.name,
                    objectives: obj.name ?? "",
                }));
            } else {
                // Otherwise, create a single row with the given roadmap
                return {
                    name: item.name,
                    objectives: item.objectives.name,
                };
            }
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateStratPlanDeps = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            // If roadmap is an array, create a row for each roadmap
            if (Array.isArray(item.dependsOn)) {
                return item.dependsOn.map((obj) => ({
                    name: item.name,
                    dependsOn: obj.name ?? "",
                }));
            } else {
                // Otherwise, create a single row with the given roadmap
                return {
                    name: item.name,
                    dependsOn: item.dependsOn.name,
                };
            }
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateProgrammes = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: refValue,
                name: item.name,
                description: item.description,
                startDate: item.actualStartDate ?? "",
                endDate: item.forecastEndDate ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateArchitectures = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: refValue,
                name: item.name,
                description: item.description,
                org1: item.org1,
                org2: item.org2,
                org3: item.org3,
                org4: item.org4,
                org5: item.org5,
                org6: item.org6,
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateProjects = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: refValue,
                name: item.name,
                description: item.description,
                startDate: item.actualStartDate ?? "",
                endDate: item.forecastEndDate ?? "",
                lifecycle: item.lifecycleStatus,
                programme: item.programme.name,
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateValStageMinTemplate = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item.id,
                parentValStream: item.valueStream.name, 
                index: item.index ?? "",
                stageName: item.label ?? "",
                description: item.description ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateValStageTemplate = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item.id,
                parentValStream: item.valueStream.name,
                parentValStage: item.parentValueStage.name ?? "",
                index: item.index ?? "",
                stageName: item.label ?? "",
                description: item.description ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generatePlanningActions = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                plan: item.plan,
                item: item.name,
                change: item.action,
                rationale: item.relation_name ?? "",
                project: item.projectName ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generatePlanPhysProcesses = (data) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                name: item.busProcessName,
                organisation: item.orgName,
                role: item.role || "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateSvcQuals = (data) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        // If there's no valid data, return an array with a single default object with empty values
        return [
            {
                id: "",
                name: "",
                description: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateIdName = (data) => { 
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item.id,
                name: item.name,
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateCJTemplate = (data, refMap, plusIdType) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        // If there's no valid data, return an array with a single default object with empty values
        return [
            {
                id: "",
                name: "",
                description: "",
                product: "",
            },
        ];
    }
 
    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }
     
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }
        
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            if (Array.isArray(item.products) && item.products.length > 0) {
                return item.products.map((product) => ({
                    id: refValue ?? "",
                    name: item?.name ?? "",
                    description: item?.description ?? "",
                    product: product?.name ?? "",
                }));
            }

            return {
                id: refValue ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
                product: item?.product?.name ?? "",
            };
        })
        .filter(Boolean);
};

const generateCJPTemplate = (data, refMap, plusIdType) => {
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                id: "",
                journey: "",
                index: "",
                phase: "",
                description: "",
                experience: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }

            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: refValue ?? "",
                journey: item?.cjp_customer_journey ?? "",
                index: item?.index ?? "",
                phase: item?.name?.replace(/.*\d+\.\s*/, "") ?? "",
                description: item?.description ?? "",
                experience: item?.cjp_experience_rating ?? "",
            };
        })
        .filter(Boolean);
};

const generateCJPtoVSTemplate = (data) => {
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                cjp: "",
                vs: "",
            },
        ];
    }

    return data.flatMap((item) => ({
        cjp: item?.cjp ?? "",
        vs: item?.vs ?? "",
    }));
};

const generateCJPtoPPTemplate = (data) => {
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                cjp: "",
                pp: "",
            },
        ];
    }

    return data.flatMap((item) => ({
        cjp: item?.cjp ?? "",
        pp: item?.pp ?? "",
    }));
};

const generateCJPtoEmot = (data) => {
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                cjp: "",
                vs: "",
            },
        ];
    }

    return data.flatMap((item) => ({
        cjp: item?.cjp ?? "",
        vs: item?.emot ?? "",
    }));
};

const generateCJPtoSQV = (data) => {
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                cjp: "",
                sqv: "",
            },
        ];
    }

    return data.flatMap((item) => ({
        cjp: item?.cjp ?? "",
        sqv: item?.sqv ?? "",
    }));
};

const generateSvcQualsVals = (data, refMap, plusIdType) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        // If there's no valid data, return an array with a single default object with empty values
        return [
            {
                id: "",
                name: "",
                value: "",
                description: "",
                colour: "",
                style: "",
                score: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: refValue ?? "",
                name: item?.name?.split(" - ")[0] ?? "",
                value: item?.value ?? "",
                description: item?.description ?? "",
                colour: item?.colour ?? "",
                style: item?.classStyle ?? "",
                score: item?.score ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateStageTemplate = (data, refMap, plusIdType) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        // If there's no valid data, return an array with a single default object with empty values
        return [
            {
                id: "",
                name: "",
                index: "",
                stagename: "",
                description: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If plusIdType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            // Safely extract 'name' and 'index' values
            const namePart = item?.name?.split(":")[0]?.trim() ?? "";
            const indexPart = (item?.name?.split(":")[1]?.match(/\d+/) || [""])[0];

            return {
                id: refValue ?? "",
                name: namePart,
                index: indexPart,
                stagename: item?.link ?? "",
                description: item?.description ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateAssessments = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                ID: refValue,
                Control_Name: item.Control_Name,
                Assessed_Business_Process: item.Assessed_Business_Process,
                Assessed_Composite_Application_Provider: item.Assessed_Composite_Application_Provider,
                Assessed_Application_Provider_Interface: item.Assessed_Application_Provider_Interface,
                Assessed_Technology_Product: item.Assessed_Technology_Product,
                Assessor: item.Assessed_Technology_Product,
                Assessment_Date: item.assessment_date,
                Outcome: item.Assessment_Date,
                Comments: item.Comments,
                Description: item.description,
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateControlAssessments = (data, refMap, plusIdType) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                ID: refValue,
                Name: item.Name,
                Description: item.Description,
                Framework: item.Framework,
                Managing_Process: item.Managing_Process,
                Managing_Process_Owner: item.Managing_Process_Owner, // Placeholder, since owner details aren't available in the data
                External_Reference_Link_Name: item.External_Reference_Link_Name,
                External_Reference_Link_URL: item.External_Reference_Link_URL,
                Assessor: item.Assessor,
                Assessment_Date: item.Assessment_Date,
                Outcome: item.Outcome,
                Comments: item.Comments,
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateEnums = (data) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        // If there's no valid data, return an array with a single default object with empty values
        return [
            {
                id: "",
                name: "",
                description: "",
                colour: "",
                styleClass: "",
                index: "",
                score: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
                colour: item?.colour ?? "",
                styleClass: item?.class ?? "",
                index: item?.seqNo ?? "",
                score: item?.score ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateCustEmotionEnums = (data) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        // If there's no valid data, return an array with a single default object with empty values
        return [
            {
                id: "",
                name: "",
                description: "",
                colour: "",
                styleClass: "",
                index: "",
                score: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If plusIdType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
                colour: item?.colour ?? "",
                styleClass: item?.class ?? "",
                index: item?.enumeration_sequence_number ?? "",
                score: item?.enumeration_score ?? "",
            };
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateCompositeSQs = (data) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        // If there's no valid data, return an array with a single default object with empty values
        return [
            { 
                name: "",
                service_quality: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            

           
            // Check if 'perfmeasures' exists and is an array
            if (!Array.isArray(item.perfmeasures) || item.perfmeasures.length === 0) {
                return [];
            }

            return item.perfmeasures.map((sq) => ({ 
                name: item?.name ?? "", // Parent name, repeated for each measure
                service_quality: sq?.name ?? "", // Performance measure name
            }));
        })
        .filter(Boolean); // Filter out null or empty values
};

const generateTPSTemplate = (data, refMap, plusIdType) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                id: "",
                name: "",
                supplier: "",
                description: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }

            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                supplier: item?.supplier ?? "",
                description: item?.description ?? "",
            };
        })
        .filter(Boolean);
};

const generateContractTypeTemplate = (data) => {
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                id: "",
                name: "",
                description: "",
                sequence: "",
                colour: "",
                styleClass: "",
                score: "",
                nmTranslate: "",
                descTranslate: "",
                language: "",
                label: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }

            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
                sequence: item?.sequence_no ?? "",
                colour: item?.backgroundColour ?? "",
                styleClass: item?.styleClass ?? "",
                score: "",
                nmTranslate: "",
                descTranslate: "",
                language: "",
                label: item?.label ?? "",
            };
        })
        .filter(Boolean);
};

const generateBModel = (data) => {
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                id: "",
                name: "",
                description: "",
                dom: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }

            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
                dom: item?.dom ?? "",
            };
        })
        .filter(Boolean);
};

const generateBModelConf = (data) => {
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                id: "",
                name: "",
                label: "",
                description: "",
                org1: "",
                org2: "",
                org3: "",
                org4: "",
                org5: "",
                org6: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }

            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.model ?? "",
                label: item?.label ?? "",
                description: item?.description ?? "",
                org1: item?.org1 ?? "",
                org2: item?.org2 ?? "",
                org3: item?.org3 ?? "",
                org4: item?.org4 ?? "",
                org5: item?.org5 ?? "",
                org6: item?.org6 ?? "",
            };
        })
        .filter(Boolean);
};

const generatesupplierRels = (data) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                id: "",
                name: "",
                description: "",
                sequence: "",
                colour: "",
                styleClass: "",
                renewalNotice: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }

            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
                sequence: item?.sequence_no ?? "",
                colour: item?.backgroundColour ?? "",
                styleClass: item?.styleClass ?? "",
                renewalNotice: item?.notice_period ?? "",
            };
        })
        .filter(Boolean);
};

//  {"name": "ID", "width": 20},{"name": "Name", "width": 30},{"name": "Description", "width": 40}, {"name": "Sequence No", "width": 30}, {"name": "Colour", "width": 40}, {"name": "Style Class", "width": 20}, {"name": "Contract Review Notice", "width": 20}],
const generateContractType2Template = (data) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                id: "",
                name: "",
                description: "",
                sequence: "",
                colour: "",
                styleClass: "",
            },
        ];
    }

    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }

            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
                sequence: item?.sequence_no ?? "",
                colour: item?.backgroundColour ?? "",
                styleClass: item?.styleClass ?? "",
            };
        })
        .filter(Boolean);
};

const generateSupplierTemplate = (data) => {
    // Ensure data is an array; if data is undefined or not an array, default to an empty array.
    if (!Array.isArray(data) || data.length === 0) {
        return [
            {
                id: "",
                name: "",
                description: "",
                relationshipStatus: "",
                link: "",
                external: "TRUE",
            },
        ];
    }

    return data
        .flatMap((item) => {
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id;
            }

            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }

            return {
                id: item?.id ?? "",
                name: item?.name ?? "",
                description: item?.description ?? "",
                relationshipStatus: item?.supplierRelStatus ?? "",
                link: item?.supplier_url ?? "",
                external: "TRUE",
            };
        })
        .filter(Boolean);
};

const generateContractTemplate = (data) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }
            return {
                id: item.id,
                suppliername: item.supplier_name,
                contractName: item.name,
                contractOwner: item.owner,
                description: item.description,
                contractType: item.contract_type,
                signDate: item.signature_date,  
                renewal: item.renewalModel,
                endDate: item.contract_end_date,
                noticePeriod: item.renewalNoticeDays,
                url: "",
            };
        })
        .filter(Boolean);
    // Filter out null or empty values
};

const generateContractComponentTemplate = (data) => {
    return data
        .flatMap((item) => {
            // Ensure item.id exists and is valid
            const hasValidId = item && item.id !== undefined && item.id !== null;
            if (!hasValidId) {
                return [];
            }

            // Determine the reference value for item.id
            let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
            if (!plusIdType) {
                refValue = item.id; // Use item.id if plusIdType is false
            }

            // If idType is true but no reference exists in refMap, skip this item
            if (plusIdType && (!refMap || !refMap[item.id])) {
                return [];
            }
            return {
                id: item.id,
                contract: item.contract_component_from_contract,
                bus: item.bus,
                app: item.app,
                tech: item.tech,
                renewaltype: item.ccr_renewal_model,
                startdate: item.ccr_start_date_ISO8601,
                noticePeriod: item.ccr_renewal_notice_days,
                unittype: item.ccr_contract_unit_of_measure,
                unitcount: item.ccr_contracted_units,
                totalcost: item.ccr_total_annual_cost,
                currency: item.ccr_currency,
                comments: "",
            };
        })
        .filter(Boolean);
    // Filter out null or empty values
};

$("document").ready(function () {
    $("#exportApplicationLifecycles").on("click", function () {
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathAppLifecycles)]).then(function (responses) {
            // Assume lifecycles is an array of lifecycle objects
            let headers = [
                { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                { name: "ID", width: 20 },
                { name: "Name", width: 40 },
            ];

            // Adding lifecycle names to the headers dynamically
            lifecycles.forEach((lifecycle) => {
                headers.push({ name: lifecycle.name, width: lifecycle.width || 40 }); // Default width is 40 if not specified
            });

            let jsonData = [];
            let appLifecycles = lifecycles.filter((d) => {
                return d.type == "Lifecycle_Status";
            });

            lifecycleModels.forEach((e) => {
                if (e.type == "Lifecycle_Model") {
                    let dataRow = {
                        id: e.id,
                        name: e.subject, // Assuming 'description' is a field in your object
                    };

                    // Mapping lifecycle dates to their corresponding headers
                    appLifecycles.forEach((lifecycle) => {
                        const match = e.dates.find((d) => d.lifecycle_status === lifecycle.id);
                        // Add each lifecycle date to the data row, ensuring order is maintained
                        dataRow[lifecycle.name] = match ? match.date : "";
                    });
                    jsonData.push(dataRow);
                }
            });
        });

        /* Final JSON structure
    dataRows.sheets.push(
        {  "id":"appLifecycles",
            "name": "Application Lifecycles",
            "description": "List of application Lifecycles",
            "notes": "Note you will need to edit yor import spec to map to the lifecycles you have defined",
            "headerRow": 7,
            "headers": headers,
            "data": jsonData, 
            "lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Capabilities"},
            {"column": "I", "values":"C", "start": 8, "end": 100, "worksheet": "Business Domains"},
            {"column": "F", "values":"C", "start": 8, "end": 100, "worksheet": "Position Lookup"}
            ] 
        })
   */
    });

    var apus;
    $("#exportApplicationIntegrations").on("click", function () {
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIDataApps), promise_loadViewerAPIData(viewAPIDataInfoRep), promise_loadViewerAPIData(viewAPIDataInfoRep), promise_loadViewerAPIData(viewAPIPathAppMart)]).then(function (responses) {
            apus = responses[3].apus;
            updateInfoArray(apus)
        
            let headers = [
                { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                { name: "ID", width: 20 },
                { name: "Name", width: 40 },
                { name: "Description", width: 40 },
            ];

            let compapps = responses[0].applications.filter((e) => {
                return e.class == "Composite_Application_Provider";
            });
            let appProapps = responses[0].applications.filter((e) => {
                return e.class == "Application_Provider";
            });

            let jsonData = generateStandardTemplate(compapps);
            let jsonDataAP = generateStandardTemplate(appProapps);
            let jsonDataInfoEx = generateStandardTemplate(responses[1].infoReps);
            let jsonDataAPI = generateStandardTemplate(apis);
            let frequencyTypesJson = generateStandardTemplate(frequencyTypes);
            let jsonDataAPIJson = generateStandardTemplate(acquisitionTypes);

            dataRows.sheets.push({ id: "frequency", name: "Frequency", description: "Frequency list", notes: " ", headerRow: 7, headers: headers, visible: false, data: frequencyTypesJson, lookup: [] });

            dataRows.sheets.push({ id: "acquisition", name: "Acquisition", description: "Acquisition list", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataAPIJson, lookup: [] });

            dataRows.sheets.push({ id: "applications", name: "Applications", description: "Captures information about the Applications used within the organisation", notes: "Use this sheet for Composite Application Providers", headerRow: 7, headers: headers, data: jsonData, lookup: [] });

            dataRows.sheets.push({ id: "applicationmodules", name: "Application Modules", description: "Captures information about the Application Modules used within the organisation", notes: "Use this sheet for Application Providers", headerRow: 7, headers: headers, data: jsonDataAP, lookup: [] });

            dataRows.sheets.push({ id: "infoExchange", name: "Information Exchanged", description: "Captures information for info exchnage between applications", notes: " ", headerRow: 7, headers: headers, data: jsonDataInfoEx, lookup: [] });

            dataRows.sheets.push({ id: "apis", name: "App Pro Interface", description: "Captures information for APIs", notes: " ", headerRow: 7, headers: headers, data: jsonDataAPI, lookup: [] });

            function updateInfoArray(dataArray) {
                return dataArray.map(data => {
                    // Create a mapping from infoData ids to their acquisition and first frequency
                    const infoDataMap = {};
                    data.infoData?.forEach(infoItem => {
                        const firstFrequency = infoItem.frequency?.length > 0 ? infoItem.frequency[0].name : "No Frequency Specified";
                        infoItem.infoReps?.forEach(rep => {
                            infoDataMap[rep.id] = {
                                acquisition: infoItem.acquisition,
                                frequency: firstFrequency
                            };
                        });
                    });
            
                    // Update the info array with matching acquisition and frequency
                    data.info?.forEach(infoItem => {
                        if (infoDataMap[infoItem.id]) {
                            infoItem.acquisition = infoDataMap[infoItem.id].acquisition;
                            infoItem.frequency = infoDataMap[infoItem.id].frequency;
                        }
                    });
            
                    return data;
                });
            }

            function processData(dataArray) {
                const sheets = {
                    "Application Dependencies CACA": [],
                    "Application Dependencies CAAP": [],
                    "Application Dependencies APCA": [],
                    "Application Dependencies APAP": [],
                    "App Interface Dependencies CACA": [],
                    "App Interface Dependencies CAAP": [],
                    "App Interface Dependencies APCA": [],
                    "App Interface Dependencies APAP": [],
                };

                function addNonAPIEntry(sheetName, targetApp, info, sourceApp, acquisition, frequency) { 
                
                    // Ensure info is an object before extracting properties
                    if (info && typeof info === 'object') {
                        acquisition = info.acquisition || acquisition || "";
                        frequency = info.frequency || frequency || "";
                        info = info.name || "";
                    } else {
                        info = "";
                    }
                
                    // Ensure defaults for missing properties
                    targetApp = targetApp || "";
                    sourceApp = sourceApp || ""; 
                
                    if (sheetName) {
                        sheets[sheetName].push({ sourceApp, info, targetApp, acquisition, frequency });
                        
                    }
                }
                
                function addAPIEntry(sheetName, targetApp, info, api, apiInfo, sourceApp, acquisition, frequency) {
      
                    // Ensure info is an object before extracting properties
                    if (info && typeof info === 'object') {
                        acquisition = info.acquisition || acquisition || "";
                        frequency = info.frequency || frequency || "";
                        info = info.name || "";
                    } else {
                        info = "";
                    }
                
                    // Ensure apiInfo is an object before extracting properties
                    if (apiInfo && typeof apiInfo === 'object') {
                        apiInfo = apiInfo.name || "";
                    } else {
                        apiInfo = "";
                    }
                    if (acquisition) {
                    } else {
                        acquisition = "";
                    }
                    if (targetApp) {
                    } else {
                        targetApp = "";
                    }
                    if (sourceApp) {
                    } else {
                        sourceApp = "";
                    }
                    if (api) {
                    } else {
                        api = "";
                    }
                    if (frequency) {
                    } else {
                        frequency = "";
                    }
          
                
                    // Ensure defaults for missing properties
                    targetApp = targetApp || "";
                    sourceApp = sourceApp || "";
                    api = api || ""; 
                
                    if (sheetName) {
                        sheets[sheetName].push({ sourceApp, info, api, apiInfo, targetApp, acquisition, frequency });
                         
                    }
                }
                

                function processEntry(entry) { 
                    const targetAppType = entry.fromApptype || entry.fromtype;
                    const sourceAppType = entry.toAppType || entry.totype;
                    const targetApp = entry.fromApp;
                    const sourceApp = entry.toApp;
                    const targetAppId = entry.fromAppId;
                    const sourceAppId = entry.toAppId;
                    const acquisition = entry.acquisition;
                    const frequency = entry.frequency;
                    const info = entry.info;

                    if (targetAppType === "Composite_Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                        if (info.length > 0) {
                            info.forEach((inf) => {
                                addNonAPIEntry("Application Dependencies CACA", targetApp, inf, sourceApp, acquisition, frequency);
                            });
                        } else {
                            addNonAPIEntry("Application Dependencies CACA", targetApp, info, sourceApp, acquisition, frequency);
                        }
                    } else if (targetAppType === "Composite_Application_Provider" && sourceAppType === "Application_Provider") {
                        addNonAPIEntry("Application Dependencies APCA", targetApp, info, sourceApp, acquisition, frequency);
                    } else if (targetAppType === "Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                        addNonAPIEntry("Application Dependencies CAAP", targetApp, info, sourceApp, acquisition, frequency);
                    } else if (targetAppType === "Application_Provider" && sourceAppType === "Application_Provider") {
                        addNonAPIEntry("Application Dependencies APAP", targetApp, info, sourceApp, acquisition, frequency);
                    }
                    if (targetAppType === "Application_Provider_Interface") {
                        let matches = apus.filter((e) => {
                            return e.toAppId == targetAppId;
                        });

                        matches.forEach((m) => {
                            let sheetName = "";

                            if ((m.fromApptype ?? m.fromtype) === "Composite_Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                                sheetName = "App Interface Dependencies CACA";
                            } else if ((m.fromApptype ?? m.fromtype) === "Composite_Application_Provider" && sourceAppType === "Application_Provider") {
                                sheetName = "App Interface Dependencies APCA";
                            } else if ((m.fromApptype ?? m.fromtype) === "Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                                sheetName = "App Interface Dependencies CAAP";
                            } else if ((m.fromApptype ?? m.fromtype) === "Application_Provider" && sourceAppType === "Application_Provider") {
                                sheetName = "App Interface Dependencies APAP";
                            }
 
                            if (m.info.length > 0) {
                                m.info.forEach((inf) => {
                                  
                                    if (info.length > 0) {
                                        info.forEach((infB) => { 
                                            addAPIEntry(sheetName, m.fromApp, infB, targetApp, inf, sourceApp, acquisition, frequency);
                                        });
                                    } else {
                                        addAPIEntry(sheetName, m.fromApp, info, targetApp, inf, sourceApp, acquisition, frequency);
                                    }
                                });
                            } else {
                                info.forEach((infB) => {
                                    addAPIEntry(sheetName, m.fromApp, infB, targetApp, m.info, sourceApp, acquisition, frequency);
                                });
                            }
                        });
                    }
                    /*
                    if(sourceAppType === "Application_Provider_Interface"){
                        let matches=apus.filter((e)=>{
                            return e.toAppId == sourceAppId
                        })
       
                     
                        matches.forEach((m)=>{
                            console.log('APIS', sourceApp)
                            console.log('API', targetApp)
                            console.log(m.fromApptype)
                            console.log(m)
                        })
                    }
                        */
                }
 
                dataArray.forEach((entry) => {
                    processEntry(entry);
                });

                return sheets;
            }

            const sheetsData = processData(apus);

            Object.keys(sheetsData).forEach((sheetName) => {
                const propertyName = sheetName.replace(/ /g, "");

                const uniqueSheetsData = [...new Map(sheetsData[sheetName].map((item) => [JSON.stringify(item), item])).values()];

                // Update the original array
                sheetsData[sheetName] = uniqueSheetsData;
                const jsonData = JSON.stringify(sheetsData[sheetName]);
                let lookups = [];
                if (sheetName == "Application Dependencies CACA") {
                    lookups = [
                        { column: "B", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                        { column: "C", values: "C", start: 8, end: 400, worksheet: "Information Exchanged" },
                        { column: "D", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                        { column: "E", values: "C", start: 8, end: 2011, worksheet: "Acquisition" },
                        { column: "F", values: "C", start: 8, end: 2011, worksheet: "Frequency" },
                    ];
                } else if (sheetName == "Application Dependencies CAAP") {
                    lookups = [
                        { column: "B", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                        { column: "C", values: "C", start: 8, end: 400, worksheet: "Information Exchanged" },
                        { column: "D", values: "C", start: 8, end: 2011, worksheet: "Application Modules" },
                        { column: "E", values: "C", start: 8, end: 2011, worksheet: "Acquisition" },
                        { column: "F", values: "C", start: 8, end: 2011, worksheet: "Frequency" },
                    ];
                } else if (sheetName == "Application Dependencies APCA") {
                    lookups = [
                        { column: "B", values: "C", start: 8, end: 2011, worksheet: "Application Modules" },
                        { column: "C", values: "C", start: 8, end: 400, worksheet: "Information Exchanged" },
                        { column: "D", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                        { column: "E", values: "C", start: 8, end: 2011, worksheet: "Acquisition" },
                        { column: "F", values: "C", start: 8, end: 2011, worksheet: "Frequency" },
                    ];
                } else if (sheetName == "Application Dependencies APAP") {
                    lookups = [
                        { column: "B", values: "C", start: 8, end: 2011, worksheet: "Application Modules" },
                        { column: "C", values: "C", start: 8, end: 400, worksheet: "Information Exchanged" },
                        { column: "D", values: "C", start: 8, end: 2011, worksheet: "Application Modules" },
                        { column: "E", values: "C", start: 8, end: 2011, worksheet: "Acquisition" },
                        { column: "F", values: "C", start: 8, end: 2011, worksheet: "Frequency" },
                    ];
                } else if (sheetName == "App Interface Dependencies CACA") {
                    lookups = [
                        { column: "B", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                        { column: "C", values: "C", start: 8, end: 400, worksheet: "Information Exchanged" },
                        { column: "D", values: "C", start: 8, end: 2011, worksheet: "App Pro Interface" },
                        { column: "E", values: "C", start: 8, end: 2011, worksheet: "Information Exchanged" },
                        { column: "F", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                        { column: "G", values: "C", start: 8, end: 2011, worksheet: "Acquisition" },
                        { column: "H", values: "C", start: 8, end: 2011, worksheet: "Frequency" },
                    ];
                } else if (sheetName == "App Interface Dependencies CAAP") {
                    lookups = [
                        { column: "B", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                        { column: "C", values: "C", start: 8, end: 400, worksheet: "Information Exchanged" },
                        { column: "D", values: "C", start: 8, end: 2011, worksheet: "App Pro Interface" },
                        { column: "E", values: "C", start: 8, end: 2011, worksheet: "Information Exchanged" },
                        { column: "F", values: "C", start: 8, end: 2011, worksheet: "Application Modules" },
                        { column: "G", values: "C", start: 8, end: 2011, worksheet: "Acquisition" },
                        { column: "H", values: "C", start: 8, end: 2011, worksheet: "Frequency" },
                    ];
                } else if (sheetName == "App Interface Dependencies APCA") {
                    lookups = [
                        { column: "B", values: "C", start: 8, end: 2011, worksheet: "Application Modules" },
                        { column: "C", values: "C", start: 8, end: 400, worksheet: "Information Exchanged" },
                        { column: "D", values: "C", start: 8, end: 2011, worksheet: "App Pro Interface" },
                        { column: "E", values: "C", start: 8, end: 2011, worksheet: "Information Exchanged" },
                        { column: "F", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                        { column: "G", values: "C", start: 8, end: 2011, worksheet: "Acquisition" },
                        { column: "H", values: "C", start: 8, end: 2011, worksheet: "Frequency" },
                    ];
                } else if (sheetName == "App Interface Dependencies APAP") {
                    lookups = [
                        { column: "B", values: "C", start: 8, end: 2011, worksheet: "Application Modules" },
                        { column: "C", values: "C", start: 8, end: 400, worksheet: "Information Exchanged" },
                        { column: "D", values: "C", start: 8, end: 2011, worksheet: "App Pro Interface" },
                        { column: "E", values: "C", start: 8, end: 2011, worksheet: "Information Exchanged" },
                        { column: "F", values: "C", start: 8, end: 2011, worksheet: "Application Modules" },
                        { column: "G", values: "C", start: 8, end: 2011, worksheet: "Acquisition" },
                        { column: "H", values: "C", start: 8, end: 2011, worksheet: "Frequency" },
                    ];
                }

                if (sheetName.toLowerCase().includes("interface")) {
                    dataRows.sheets.push({
                        id: propertyName,
                        name: sheetName,
                        headerRow: 7,
                        headers: [
                            { name: "", width: 20 },
                            { name: "Source Application", width: 40 },
                            { name: "Information Exchanged", width: 40 },
                            { name: "Interface App Used", width: 60 },
                            { name: "Information Exchanged", width: 40 },
                            { name: "Target Application", width: 20 },
                            { name: "Acquisition Method", width: 10 },
                            { name: "Frequency", width: 30 },
                        ],
                        data: JSON.parse(jsonData),
                        lookup: lookups,
                    });
                } else {
                    dataRows.sheets.push({
                        id: propertyName,
                        name: sheetName,
                        headerRow: 7,
                        headers: [
                            { name: "", width: 20 },
                            { name: "Source Application", width: 40 },
                            { name: "Information Exchanged", width: 40 },
                            { name: "Target Application", width: 20 },
                            { name: "Acquisition Method", width: 10 },
                            { name: "Frequency", width: 30 },
                        ],
                        data: JSON.parse(jsonData),
                        lookup: lookups,
                    });
                }
            });
            createPlusWorkbookFromJSON();
        });
    });

    $("#exportStrategicPlans").on("click", function () {
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIDataBusCaps), promise_loadViewerAPIData(viewAPIDataBusProcs), promise_loadViewerAPIData(viewAPIDataAppSvcs), promise_loadViewerAPIData(viewAPIDataOrgs), promise_loadViewerAPIData(viewAPIDataApps), promise_loadViewerAPIData(viewAPIDataTechComp), promise_loadViewerAPIData(viewAPIDataTechProd), promise_loadViewerAPIData(viewAPIPathPlansProjs), promise_loadViewerAPIData(viewAPIPathStrategic)]).then(function (responses) {
            // Assume lifecycles is an array of lifecycle objects
            let headers = [
                { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                { name: "ID", width: 20 },
                { name: "Name", width: 40 },
                { name: "Description", width: 60 },
            ];

            let jsonDataRoadmap = generateStandardTemplateInternalId(responses[7].roadmaps, refMap, plusIdType);

            dataRows.sheets.push({ id: "roadmaps", name: "Roadmaps", description: "list of Roadmaps", notes: " ", headerRow: 7, headers: headers, visible: true, data: jsonDataRoadmap, lookup: [] });

            let jsonDataPlanning = generateStandardTemplate(allPlanningAction);
            dataRows.sheets.push({ id: "allPlanningActions", name: "Planning Actions", description: "list of Planning Actions", notes: "", headerRow: 7, headers: headers, visible: false, data: jsonDataPlanning, lookup: [] });

            let jsonDataProjLifes = generateStandardTemplate(allprojlifecycle);
            dataRows.sheets.push({ id: "allProjectLifecycle", name: "Project Lifecycles", description: "list of Project Lifecycles", notes: "", headerRow: 7, headers: headers, visible: false, data: jsonDataProjLifes, lookup: [] });

            let jsonDataStratPlanList = generateStandardTemplateInternalId(responses[7].allPlans);
            dataRows.sheets.push({ id: "allStratPlanList", name: "Strat Plan List", description: "list of unique Strat plans for dropdown", notes: "", headerRow: 7, headers: headers, visible: true, data: jsonDataStratPlanList, lookup: [] });

            let jsonData = generateStandardTemplate(responses[0].businessCapabilities);

            dataRows.sheets.push({ id: "busCaps", name: "Business Capabilities", description: "list of Business Capabilities", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonData, lookup: [] });

            let jsonDataBP = generateStandardTemplate(responses[1].businessProcesses);

            dataRows.sheets.push({ id: "busProcesses", name: "Business Processes", description: "list of Business Processes", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataBP, lookup: [] });
            let jsonDataAS = generateStandardTemplate(responses[2].application_services);

            dataRows.sheets.push({ id: "appServices", name: "Application Services", description: "list of Application Services", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataAS, lookup: [] });
            let jsonDataOrg = generateStandardTemplate(responses[3].organisations);

            dataRows.sheets.push({ id: "orgs", name: "Organisation", description: "list of Organisations", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataOrg, lookup: [] });
            let jsonDataApp = generateStandardTemplate(responses[4].applications);

            dataRows.sheets.push({ id: "Applications", name: "Applications", description: "list of Applications", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataApp, lookup: [] });

            responses[5].technology_components = responses[5].technology_components.sort((a, b) => { 
                return a.name.localeCompare(b.name);
              });

            let jsonDataTC = generateStandardTemplate(responses[5].technology_components);

            dataRows.sheets.push({ id: "techComponents", name: "Technology Components", description: "list of Technology Components", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataTC, lookup: [] });

            responses[6].technology_products = responses[6].technology_products.sort((a, b) => { 
                return a.name.localeCompare(b.name);
              });
            let jsonDataTP = generateStandardTemplate(responses[6].technology_products);

            dataRows.sheets.push({ id: "techProducts", name: "Technology Products", description: "list of Technology Products", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataTP, lookup: [] });

            let jsonDataObj = generateStandardTemplateInternalId(responses[8].objectives, refMap);

            dataRows.sheets.push({ id: "objectives", name: "Objectives", description: "list of Objectives", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataObj, lookup: [] });

            let stratPlans = responses[7].allPlans;
            let stratPlanp2e=[];
            stratPlans.forEach((plan) => {
                // Initialize the 'roadmaps' property as an empty array in each plan
                plan.roadmaps = [];

                // Loop through each roadmap in Roamaps
                responses[7].roadmaps.forEach((roadmap) => {
                    // Check if the plan id exists in the strategicPlans array of the roadmap
                    if (roadmap.strategicPlans.includes(plan.id)) {
                        // Add the roadmap name to the roadmaps array of the plan
                        plan.roadmaps.push(roadmap.name);
                    }
                });
                stratPlanp2e =[...stratPlanp2e, ...plan.planP2E]

            });

            let jsonDataStratPlans = generateStratPlans(responses[7].allPlans, refMap, plusIdType);

            dataRows.sheets.push({
                id: "stratPlans",
                name: "Strategic Plans",
                description: "list of Strategic Plan",
                notes: "A strategic plan may appear more than once where it is mapped to multiple roadmaps, ensure the data is the same for all fields",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Roadmap", width: 40 },
                    { name: "Strategic Plan name", width: 40 },
                    { name: "Description", width: 60 },
                    { name: "Start Date", width: 20 },
                    { name: "End Date", width: 20 },
                ],
                visible: true,
                data: jsonDataStratPlans,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Roadmaps" }],
            });

            let jsonDataStratPlantoObjs = generateStratPlansObj(responses[7].allPlans, refMap, plusIdType);

            dataRows.sheets.push({
                id: "stratPlansObj",
                name: "Strat Plan Objectives",
                description: "list of Strategic Plan to Objectives",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Objective", width: 40 },
                ],
                visible: true,
                data: jsonDataStratPlantoObjs,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Objectives" },
                ],
            });

            const extendDependsOnWithPlanNames = (allPlans) => {
                return allPlans.map((plan) => {
                    // Check if the plan has dependsOn
                    if (plan.dependsOn && plan.dependsOn.length > 0) {
                        // Extend dependsOn with the corresponding plan names
                        const extendedDependsOn = plan.dependsOn.map((depId) => {
                            // Find the plan that matches the dependsOn id
                            const matchedPlan = allPlans.find((p) => p.id === depId);
                            // Return an object that includes both the ID and the name of the matched plan
                            return {
                                id: depId,
                                name: matchedPlan ? matchedPlan.name : "", // Fallback if plan not found
                            };
                        });

                        // Update the dependsOn with the extended data
                        return {
                            ...plan,
                            dependsOn: extendedDependsOn,
                        };
                    }

                    // If no dependsOn, return the plan as is
                    return plan;
                });
            };

            // Use the function to extend the dependsOn property
            const allPlans = extendDependsOnWithPlanNames(responses[7].allPlans);

            // Example usage

            let jsonDataStratPlanDeps = generateStratPlanDeps(allPlans, refMap, plusIdType);

            dataRows.sheets.push({
                id: "stratPlansDeps",
                name: "Strat Plan Dependencies",
                description: "list of Strategic Plan dependencies",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Depends on Plan", width: 40 },
                ],
                visible: true,
                data: jsonDataStratPlanDeps,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                ],
            });

            let jsonDataProgrammes = generateProgrammes(responses[7].programmes, refMap, plusIdType);

            dataRows.sheets.push({
                id: "programmes",
                name: "Programmes",
                description: "list of Programmes",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Programme Name", width: 40 },
                    { name: "Description", width: 60 },
                    { name: "Start Date", width: 20 },
                    { name: "End Date", width: 20 },
                ],
                visible: true,
                data: jsonDataProgrammes,
                lookup: [],
            });

            const updateProjectProgrammes = (projects, programmes) => {
                return projects.map((project) => {
                    // Find the corresponding programme by ID in the `programmes` array
                    const matchedProgramme = programmes.find((p) => p.id === project.programme);

                    // If a matching programme is found, update the `programme` property to include the name
                    if (matchedProgramme) {
                        return {
                            ...project,
                            programme: {
                                id: project.programme,
                                name: matchedProgramme.name,
                            },
                        };
                    }

                    // If no matching programme is found, return the project as is
                    return project;
                });
            };

            // Use the function to extend the dependsOn property
            const allProj = updateProjectProgrammes(responses[7].allProject, responses[7].programmes);

            let jsonDataProjects = generateProjects(allProj, refMap, plusIdType);

            dataRows.sheets.push({
                id: "projects",
                name: "Projects",
                description: "list of Projects",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                    { name: "Start Date", width: 20 },
                    { name: "End Date", width: 20 },
                    { name: "Lifecycle", width: 20 },
                    { name: "Parent Programme", width: 40 },
                ],
                visible: true,
                data: jsonDataProjects,
                lookup: [
                    { column: "G", values: "C", start: 8, end: 2011, worksheet: "Project Lifecycles" },
                    { column: "H", values: "C", start: 8, end: 2011, worksheet: "Programmes" },
                ],
            });


            // Function to combine and group `p2e` items by `eletype`
            const groupP2EByEletype = (projects) => {
                // Combine all p2e items from all projects, adding the project name
                let combinedP2EItems = projects.flatMap((project) =>
                    (project.p2e || []).map((p2eItem) => ({
                        ...p2eItem,
                        projectName: project.name, // Add the project name to each p2e item
                      
                    }))
                );
             
                const mergedP2EItems = [...combinedP2EItems, ...stratPlanp2e].reduce((acc, item) => {
                    const existingItem = acc.get(item.id) || {};
                
                    acc.set(item.id, {
                        ...existingItem,
                        ...item, 
                        plan: item.plan || (item.planInfo ? item.planInfo.name : existingItem.plan), // Ensure plan is set
                    });
                
                    return acc;
                }, new Map());
                

                combinedP2EItems  = Array.from(mergedP2EItems.values());

                // Group by eletype
                return combinedP2EItems.reduce((acc, p2eItem) => {
                    // Get the eletype of the current p2e item
                    const eletype = p2eItem.eletype || "Unknown";

                    // Initialize the group if not present
                    if (!acc[eletype]) {
                        acc[eletype] = [];
                    }

                    // Add the current p2e item to the appropriate group
                    acc[eletype].push(p2eItem);

                    return acc;
                }, {});
            };
           
            let allp2e = groupP2EByEletype(allProj);
       
            const compsApplications = allp2e["Composite_Application_Provider"] || [];
            const applications = allp2e["Application_Provider"] || [];
 
            const combinedApplications = [...compsApplications, ...applications];
            
            let jsonDataAppActions = generatePlanningActions(combinedApplications, refMap, plusIdType);
 
            dataRows.sheets.push({
                id: "appPlanningActions",
                name: "App Planning Actions",
                description: "list of Application Planning Actions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Impacted Application", width: 40 },
                    { name: "Planned Change", width: 20 },
                    { name: "Change Rationale", width: 30 },
                    { name: "Implementing Project", width: 40 },
                ],
                visible: true,
                data: jsonDataAppActions,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Planning Actions" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Projects" },
                ],
            });

            const appSvc = allp2e["Application_Service"] || [];

            let jsonDataAppActionsSvc = generatePlanningActions(appSvc, refMap, plusIdType);

            dataRows.sheets.push({
                id: "appSvcPlanningActions",
                name: "App Svc Planning Actions",
                description: "list of Application Service Planning Actions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Impacted Application Service", width: 40 },
                    { name: "Planned Change", width: 20 },
                    { name: "Change Rationale", width: 30 },
                    { name: "Implementing Project", width: 40 },
                ],
                visible: true,
                data: jsonDataAppActionsSvc,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Application Services" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Planning Actions" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Projects" },
                ],
            });

            const busCap = allp2e["Business Capability"] || [];

            let jsonDataBCActionsc = generatePlanningActions(busCap, refMap, plusIdType);

            dataRows.sheets.push({
                id: "bcPlanningActions",
                name: "Bus Cap Planning Actions",
                description: "list of Business Capability Planning Actions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Impacted Business Capability", width: 40 },
                    { name: "Planned Change", width: 20 },
                    { name: "Change Rationale", width: 30 },
                    { name: "Implementing Project", width: 40 },
                ],
                visible: true,
                data: jsonDataBCActionsc,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Capabilities" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Planning Actions" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Projects" },
                ],
            });

            const busProc = allp2e["Business Process"] || [];

            let jsonDataBPActions = generatePlanningActions(busProc, refMap, plusIdType);

            dataRows.sheets.push({
                id: "bpPlanningActions",
                name: "Bus Proc Planning Actions",
                description: "list of Business Process Planning Actions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Impacted Business Process", width: 40 },
                    { name: "Planned Change", width: 20 },
                    { name: "Change Rationale", width: 30 },
                    { name: "Implementing Project", width: 40 },
                ],
                visible: true,
                data: jsonDataBPActions,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Processes" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Planning Actions" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Projects" },
                ],
            });

            const org = allp2e["Group Actor"] || [];

            let jsonDataOrgActions = generatePlanningActions(org, refMap, plusIdType);

            dataRows.sheets.push({
                id: "orgPlanningActions",
                name: "Org Planning Actions",
                description: "list of Organisation Planning Actions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Impacted Organisation", width: 40 },
                    { name: "Planned Change", width: 20 },
                    { name: "Change Rationale", width: 30 },
                    { name: "Implementing Project", width: 40 },
                ],
                visible: true,
                data: jsonDataOrgActions,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Organisation" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Planning Actions" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Projects" },
                ],
            });

            const techComp = allp2e["Technology Component"] || [];

            let jsonDataTCActions = generatePlanningActions(techComp, refMap, plusIdType);

            dataRows.sheets.push({
                id: "tcPlanningActions",
                name: "Tech Comp Planning Actions",
                description: "list of Technology Component Planning Actions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Impacted Technology Component", width: 40 },
                    { name: "Planned Change", width: 20 },
                    { name: "Change Rationale", width: 30 },
                    { name: "Implementing Project", width: 40 },
                ],
                visible: true,
                data: jsonDataTCActions,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Technology Components" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Planning Actions" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Projects" },
                ],
            });

            const techProd = allp2e["Technology Product"] || [];

            let jsonDataTPActions = generatePlanningActions(techProd, refMap, plusIdType);

            dataRows.sheets.push({
                id: "tpPlanningActions",
                name: "Tech Prod Planning Actions",
                description: "list of Technology Product Planning Actions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Strategic Plan", width: 40 },
                    { name: "Impacted Technology Product", width: 40 },
                    { name: "Planned Change", width: 20 },
                    { name: "Change Rationale", width: 30 },
                    { name: "Implementing Project", width: 40 },
                ],
                visible: true,
                data: jsonDataTPActions,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Strat Plan List" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Technology Products" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Planning Actions" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Projects" },
                ],
            });

            createPlusWorkbookFromJSON();
        });

        /* Final JSON structure
    dataRows.sheets.push(
        {  "id":"appLifecycles",
            "name": "Application Lifecycles",
            "description": "List of application Lifecycles",
            "notes": "Note you will need to edit yor import spec to map to the lifecycles you have defined",
            "headerRow": 7,
            "headers": headers,
            "data": jsonData, 
            "lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Capabilities"},
            {"column": "I", "values":"C", "start": 8, "end": 100, "worksheet": "Business Domains"},
            {"column": "F", "values":"C", "start": 8, "end": 100, "worksheet": "Position Lookup"}
            ] 
        })
    */
    });

    function createRows(data) {
        const rows = [];

        data.forEach((control) => {
            control.controlSolutions.forEach((controlSolution) => { 
                let lastAssessmentCaptured = controlSolution.thisassessments[controlSolution.thisassessments.length - 1];
                controlSolution.thisprocesses.forEach((process) => {
                    const row = {
                        id: controlSolution.id,
                        Name: control.name,
                        Description: control.description,
                        Framework: control.framework,
                        Managing_Process: process.name,
                        Managing_Process_Owner: process.owner, // Placeholder, since owner details aren't available in the data
                        External_Reference_Link_Name: process.extName,
                        External_Reference_Link_URL: process.externalLinks,
                        Assessor: lastAssessmentCaptured.control_solution_assessor,
                        Assessment_Date: lastAssessmentCaptured.assessment_date,
                        Outcome: lastAssessmentCaptured.assessment_finding,
                        Comments: lastAssessmentCaptured.assessment_comments,
                    };
                    rows.push(row);
                });
            });
        });

        return rows;
    }

    function createControlStructure(data) {
        const rows = [];

        data.forEach((cas) => {
            cas.controlAssessessments?.forEach((item) => {
                item.elements?.forEach((element) => {
                    let lastAssessmentCaptured = item.assessments[item.assessments.length - 1];
                    const row = {
                        Control_Name: cas.name,
                        Assessed_Business_Process: element.type === "Business_Process" ? element.name : "",
                        Assessed_Composite_Application_Provider: element.type === "Composite_Application_Provider" ? element.name : "",
                        Assessed_Application_Provider: element.type === "Application_Provider" ? element.name : "",
                        Assessed_Application_Provider_Interface: element.type === "Application_Provider_Interface" ? element.name : "",
                        Assessed_Technology_Product: element.type === "Technology_Product" ? element.name : "",
                        Assessor: lastAssessmentCaptured.control_solution_assessor,
                        Assessment_Date: lastAssessmentCaptured.assessment_date,
                        Outcome: lastAssessmentCaptured.assessment_finding,
                        Comments: lastAssessmentCaptured.assessment_comments,
                        description: item.description || "",
                    };

                    rows.push(row);
                });
            });
        });
        return rows;
    }

    $("#exportControlFramework").on("click", function () {
        dataRows = { sheets: [] };
  
        Promise.all([promise_loadViewerAPIData(viewAPIPathAppCapMartKPI), promise_loadViewerAPIData(viewAPIPathControls), promise_loadViewerAPIData(viewAPIDataBusProcs), promise_loadViewerAPIData(viewAPIDataTechProd)]).then(function (responses) {
            const rows = createRows(responses[1].control);
            const controlAssessRows = createControlStructure(responses[1].control);
       
            let assessrows = generateControlAssessments(rows, refMap, plusIdType);
            let headers = [
                { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                { name: "ID", width: 20 },
                { name: "Name", width: 40 },
                { name: "Description", width: 40 },
            ];

           
            dataRows.sheets.push({
                id: "controlAssess",
                name: "Control Framework Assessment",
                description: "Controls for the framework",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Control Name", width: 30 },
                    { name: "Description", width: 60 },
                    { name: "Framework", width: 30 },
                    { name: "Managing Process", width: 40 },
                    { name: "Managing Process Owner", width: 40 },
                    { name: "External Reference Link Name", width: 30 },
                    { name: "External Reference Link URL", width: 30 },
                    { name: "Assessor", width: 40 },
                    { name: "Assessment Date", width: 20 },
                    { name: "Outcome", width: 30 },
                    { name: "Comments", width: 60 },
                ],
                visible: true,
                data: assessrows,
                lookup: [
                    { column: "F", values: "C", start: 8, end: 5011, worksheet: "Business Processes" },
                    { column: "G", values: "C", start: 8, end: 5011, worksheet: "Individuals Lookup" },
                ],
            });

            let jsonDataBP = generateStandardTemplate(responses[2].businessProcesses);

            dataRows.sheets.push({ id: "busProcesses", name: "Business Processes", description: "list of Business Processes", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataBP, lookup: [] });
 
            let jsonDataApp = generateStandardTemplate(responses[0].applications.filter((d)=>{return d.class=='Composite_Application_Provider'}));

            dataRows.sheets.push({ id: "Applications", name: "Applications", description: "list of Applications", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataApp, lookup: [] });
          
            let jsonDataAppPro = generateStandardTemplate(responses[0].applications.filter((d)=>{return d.class=='Application_Provider'}));
            dataRows.sheets.push({ id: "ApplicationModules", name: "Application Modules", description: "list of Application Modules", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataAppPro, lookup: [] });
          
            
            let jsonDataAPI = generateStandardTemplate(responses[0].apis);

            dataRows.sheets.push({ id: "Application Provider Interfaces", name: "APIs", description: "list of APIs", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataAPI, lookup: [] });

            responses[3].technology_products = responses[3].technology_products.sort((a, b) => { 
                return a.name.localeCompare(b.name);
              });

            let jsonDataTP = generateStandardTemplate(responses[3].technology_products);

            dataRows.sheets.push({ id: "techProducts", name: "Technology Products", description: "list of Technology Products", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataTP, lookup: [] });

            let jsonDataIndividualLookup = generateStandardTemplate(allIndividuals);

            dataRows.sheets = dataRows.sheets.filter((sheet) => sheet.id !== "indivLookup");
            


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

            dataRows.sheets.push({
                id: "controlCompAssess",
                name: "Control Compliance Assessment",
                description: "Use this sheet to load  the assessments of the elements against the control",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "Control Name", width: 30 },
                    { name: "Assessed Business Process", width: 60 },
                    { name: "Assessed Composite Application Provider", width: 30 },
                    { name: "Assessed Application Provider", width: 30 },
                    { name: "Assessed Application Provider Interface", width: 40 },
                    { name: "Assessed Technology Product", width: 40 },
                    { name: "Assessor", width: 30 },
                    { name: "Assessment Date", width: 20 },
                    { name: "Outcome", width: 30 },
                    { name: "Comments", width: 60 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: controlAssessRows,
                lookup: [
                    { column: "C", values: "C", start: 8, end: 5011, worksheet: "Business Processes" },
                    { column: "D", values: "C", start: 8, end: 5011, worksheet: "Applications" },
                    { column: "E", values: "C", start: 8, end: 5011, worksheet: "ApplicationModules" },
                    { column: "F", values: "C", start: 8, end: 5011, worksheet: "APIs" },
                    { column: "G", values: "C", start: 8, end: 5011, worksheet: "Technology Products" },
                    { column: "H", values: "C", start: 8, end: 5011, worksheet: "Individuals Lookup" },
                ],
            });

            createPlusWorkbookFromJSON();
        });
    });

    $("#exportStratPlanner").on("click", function () {
        
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathStratPlanner)]).then(function (responses) {
            let custEx = responses[0].custEx;
            let custEmotions = responses[0].custEmotions;
            let custServiceQual = responses[0].custServiceQual;
            let custServiceQualVal = responses[0].custServiceQualVal;
            let custJourney = responses[0].custJourney;
            let custJourneyPhase = responses[0].custJourneyPhase;
 
            //   Products, CEX Ratings, Cust Emotions, Cust SQ, Ciust SQVs, Value MediaStreamAudioSourceNode, value Stages

            let headers = [
                { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                { name: "ID", width: 20 },
                { name: "Name", width: 40 },
                { name: "Description", width: 40 },
            ];

            // Assuming responses[0].physProcesses and physProcesses are arrays with objects containing an ID field
            physProcesses.forEach((process) => {
                // Find the matching object in responses[0].physProcesses by ID
                let matchingResponseProcess = responses[0].physProcesses.find((responseProcess) => responseProcess.id === process.id);

                // If a match is found, merge the objects (you can specify how to merge)
                if (matchingResponseProcess) {
                    process["busProcessName"] = matchingResponseProcess.busProcessName;
                    process["orgName"] = matchingResponseProcess.orgName;
                } else {
                    // If no match is found, push the process into responses[0].physProcesses
                    responses[0].physProcesses.push(process);
                }
            });
            physProcesses = physProcesses.filter((p) => {
                return p.orgName;
            });
            let jsonDataPhysProc = generatePlanPhysProcesses(physProcesses, refMap, plusIdType);
            dataRows.sheets.push({
                id: "physPro",
                name: "Physical Processes",
                description: "Physical Processes",
                notes: "IMPORTANT: You MUST delete the cells E or F before loading.  If Org role is populated then delete column F, otherwise delete column E, DO NOT delete column G.  DO NOT ADD NEW DATA HERE",
                headerRow: 7,
                headers: [
                    // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "", width: 20 },
                    { name: "Business Process", width: 20 },
                    { name: "Organisation", width: 30 },
                    { name: "Organisational Role", width: 60 },
                ],
                visible: true,
                data: jsonDataPhysProc,
                lookup: [],
                concatenate: [
                    {
                        column: "E",
                        type: "=CONCATENATE",
                        formula: 'C, " as ", D, " performing ", B',
                    },
                    {
                        column: "F",
                        type: "=CONCATENATE",
                        formula: 'C, " performing ", B',
                    },
                    {
                        column: "G",
                        type: "=CONCATENATE",
                        formula: "E, F",
                    },
                ],
            });

            let jsonProducts = generateStandardTemplate(allProducts);

            dataRows.sheets.push({ id: "products", name: "Products", description: "Product List", notes: "", headerRow: 7, headers: headers, visible: true, data: jsonProducts, lookup: [] });

            let jsonCustEx = generateEnums(custEx);

            let jsonCustEmotion = generateEnums(custEmotions);

            dataRows.sheets.push({
                id: "custexRatings",
                name: "Customer Experience Ratings",
                description: "Set Customer Experience Ratings",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Experience Rating", width: 30 },
                    { name: "Description", width: 60 },
                    { name: "Colour", width: 15 },
                    { name: "Style Class", width: 20 },
                    { name: "Index", width: 15 },
                    { name: "Score", width: 15 },
                ],
                visible: true,
                data: jsonCustEx,
                lookup: [],
            });

            dataRows.sheets.push({
                id: "custemRatings",
                name: "Customer Emotion Ratings",
                description: "Set Customer Emotion Ratings",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Emotion name", width: 30 },
                    { name: "Description", width: 60 },
                    { name: "Colour", width: 15 },
                    { name: "Style Class", width: 20 },
                    { name: "Index", width: 15 },
                    { name: "Score", width: 15 },
                ],
                visible: true,
                data: jsonCustEmotion,
                lookup: [],
            });

            let svqJson = generateSvcQuals(custServiceQual, refMap, plusIdType);
            let svqvalsJson = generateSvcQualsVals(custServiceQualVal, refMap, plusIdType);

            dataRows.sheets.push({
                id: "custservquals",
                name: "Customer Service Qualities",
                description: "Set Customer Service Qualities",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 30 }, 
                    { name: "Description", width: 60 }
                ],
                visible: true,
                data: svqJson,
                lookup: [],
            });

            dataRows.sheets.push({
                id: "custSQV",
                name: "Customer Service Quality Values",
                description: "Set Customer Experience Ratings",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 30 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 60 },
                    { name: "Colour", width: 20 },
                    { name: "Style Class", width: 20 },
                    { name: "Score", width: 10 },
                    { name: "Name Translation", width: 60 },
                    { name: "Description Translation", width: 60 },
                    { name: "Language", width: 60 },
                ],
                visible: true,
                data: svqvalsJson,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Customer Service Qualities" }],
                concatenate: [
                    {
                        column: "G",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
            });

            let jsonValStreams = generateStandardTemplateInternalId(responses[0].valueStreams, refMap, plusIdType);

            dataRows.sheets.push({
                id: "valueStreams",
                name: "Value Streams",
                description: "Value Stream List",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonValStreams,
                lookup: [],
            });

            let jsonValStage = generateValStageMinTemplate(responses[0].valueStages, refMap, plusIdType);

            dataRows.sheets.push({
                id: "valueStreams",
                name: "Value Stages",
                description: "Value Stage List",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Value Stream", width: 30 },
                    { name: "Index", width: 20 },
                    { name: "Stage Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonValStage,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Value Streams" }],
                concatenate: {
                    column: "G",
                    type: "=CONCATENATE",
                    formula: 'C, ": ", D, ". ", E',
                },
            });

            let jsonCustJourney = generateCJTemplate(custJourney, refMap, plusIdType);

            dataRows.sheets.push({
                id: "custjourneys",
                name: "Customer Journeys",
                description: "Customer Journey List",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 60 },
                    { name: "Product", width: 40 },
                ],
                visible: true,
                data: jsonCustJourney,
                lookup: [{ column: "E", values: "C", start: 8, end: 2011, worksheet: "Products" }],
            });

            let jsonCustJourneyPhases = generateCJPTemplate(custJourneyPhase, refMap, plusIdType);

            dataRows.sheets.push({
                id: "custjourneyphases",
                name: "Customer Journey Phases",
                description: "Customer Journey Phase List",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Customer Journey", width: 30 },
                    { name: "Index", width: 10 },
                    { name: "Phase Name", width: 30 },
                    { name: "Description", width: 60 },
                    { name: "Customer Experience", width: 40 },
                ],
                visible: true,
                data: jsonCustJourneyPhases,
                lookup: [
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Customer Journeys" },
                    { column: "G", values: "C", start: 8, end: 2011, worksheet: "Customer Experience Ratings" },
                ],
                concatenate: {
                    column: "H",
                    type: "=CONCATENATE",
                    formula: 'C, ": ", D, ". ", E',
                },
            });

            let mappedCjptoVs = [];
            responses[0].valueStages.forEach((vs) => {
                vs.customerJourneyPhaseIds.forEach((cj) => {
                    let phase = custJourneyPhase.find((p) => {
                        return p.id == cj;
                    });
                    mappedCjptoVs.push({ cjp: phase.name, vs: vs.name });
                });
            });
            let jsonCJPtoVS = generateCJPtoVSTemplate(mappedCjptoVs);

            dataRows.sheets.push({
                id: "cjptovs",
                name: "CJPs to Value Stages",
                description: "Customer Journey Phase mapped to Value Stages",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Customer Journey Phase", width: 40 },
                    { name: "Value Stage", width: 40 },
                ],
                visible: true,
                data: jsonCJPtoVS,
                lookup: [
                    { column: "B", values: "H", start: 8, end: 2011, worksheet: "Customer Journey Phases" },
                    { column: "C", values: "G", start: 8, end: 2011, worksheet: "Value Stages" },
                ],
            });

            let mappedCjptoPhysProc = [];
            let bsqvs = [];
            let emot = [];

            custJourneyPhase.forEach((cjp) => {
                cjp.emotions.forEach((e) => {
                    emot.push({ cjp: cjp.name, emot: e.name });
                });
                cjp.physProcs.forEach((pp) => {
                    
                    mappedCjptoPhysProc.push({ cjp: cjp.name, pp: pp.name });
                });
                cjp.bsqvs.forEach((sqv) => {
                    bsqvs.push({ cjp: cjp.name, sqv: sqv.name });
                });
            });

            let jsonCJPtoPhysProc = generateCJPtoPPTemplate(mappedCjptoPhysProc);

            dataRows.sheets.push({
                id: "cjptopp",
                name: "CJPs to Physical Process",
                description: "Customer Journey Phase mapped to Physical Processes",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Customer Journey Phase", width: 40 },
                    { name: "Physical Process", width: 40 },
                ],
                visible: true,
                data: jsonCJPtoPhysProc,
                lookup: [
                    { column: "B", values: "H", start: 8, end: 2011, worksheet: "Customer Journey Phases" },
                    { column: "C", values: "G", start: 8, end: 2011, worksheet: "Physical Processes" },
                ],
            });


            let jsonCJPtoEmotions = generateCJPtoEmot(emot);

            dataRows.sheets.push({
                id: "cjptopp",
                name: "CJPs to Emotions",
                description: "Customer Journey Phase mapped to Emotions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Customer Journey Phase", width: 40 },
                    { name: "Emotions", width: 40 },
                ],
                visible: true,
                data: jsonCJPtoEmotions,
                lookup: [
                    { column: "B", values: "H", start: 8, end: 2011, worksheet: "Customer Journey Phases" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Customer Emotion Ratings" },
                ],
            });

            let jsonCJPtoBSQV = generateCJPtoSQV(bsqvs);
            dataRows.sheets.push({
                id: "cjptobsqv",
                name: "CJPs to Service Quality Values",
                description: "Customer Journey Phase mapped to Business Service Quality Values",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Customer Journey Phase", width: 40 },
                    { name: "Service Quality Value", width: 40 },
                ],
                visible: true,
                data: jsonCJPtoBSQV,
                lookup: [
                    { column: "B", values: "H", start: 8, end: 2011, worksheet: "Customer Journey Phases" },
                    { column: "C", values: "G", start: 8, end: 2011, worksheet: "Customer Service Quality Values" },
                ],
            });
            createPlusWorkbookFromJSON();
        });
    });

    $("#exportTechRef").on("click", function () {
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIDataApps), promise_loadViewerAPIData(viewAPIDataTechComp), promise_loadViewerAPIData(viewAPIDataTechProd), promise_loadViewerAPIData(viewAPIPathApptoTech)]).then(function (responses) {
            let headers = [
                { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                { name: "ID", width: 20 },
                { name: "Name", width: 40 },
            ];
    
            let jsonDataTechComposite = generateStandardTemplateInternalId(techComposites);

            dataRows.sheets.push({
                id: "techrefarch",
                name: "Tech Reference Archs",
                description: "list of Technology Reference Architectures",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 40 },
                ],
                visible: true,
                data: jsonDataTechComposite,
                lookup: [],
            });

            let jsonDataTechCompositeSQs = generateCompositeSQs(techComposites);

            dataRows.sheets.push({
                id: "techrefarchsqs",
                name: "Tech Ref Arch Svc Quals",
                description: "list of Technology Reference Architecture Service Qualities",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, 
                    { name: "Reference Architecture", width: 40 },
                    { name: "Service Quality Value", width: 40 },
                ],
                visible: true,
                data: jsonDataTechCompositeSQs,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Tech Reference Archs" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "TSQV Lookup" },
                ],
            });

            let tras = [];
            techComposites.forEach((tc) => {
                tc.tcus.forEach((t) => {
                    let match = responses[1].technology_components.find((a) => {
                        return a.id == t.from_technology_component;
                    });
                    t["component_name"] = match.name;
                    t.dependsOn.forEach((d) => {
                        let match = responses[1].technology_components.find((a) => {
                            return a.id == d.to;
                        });
                        d["component_name"] = match.name;
                        tras.push({ name: tc.name, from: match.name, to: t.component_name });
                    });
                });
            });

            dataRows.sheets.push({
                id: "techrefmodels",
                name: "Tech Reference Models",
                description: "list of Technology Reference Models",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "Reference Architecture", width: 20 },
                    { name: "From Technology Component", width: 40 },
                    { name: "To Technology Component", width: 40 },
                ],
                visible: true,
                data: tras,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Tech Reference Archs" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Technology Components" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Technology Components" },
                ],
            });

            let apptech = [];
            responses[3].application_technology_architecture.forEach((d) => {
                d.supportingTech.forEach((t) => {
                    if (t.environmentName) {
                        apptech.push({ name: d.application, env: t.environmentName, fromTech: t.fromTechProduct, fromComp: t.fromTechComponent, toTech: t.toTechProduct, toComp: t.toTechComponent });
                    }
                });
            });

            dataRows.sheets.push({
                id: "apptotechprods",
                name: "App to Tech Products",
                description: "Application to Technology Mapping",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "Application", width: 20 },
                    { name: "Environment", width: 40 },
                    { name: "From Technology Product", width: 40 },
                    { name: "From Technology Component", width: 40 },
                    { name: "To Technology Product", width: 40 },
                    { name: "To Technology Component", width: 40 },
                ],
                visible: true,
                data: apptech,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Applications" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Technology Products" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Technology Components" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Technology Products" },
                    { column: "G", values: "C", start: 8, end: 2011, worksheet: "Technology Components" },
                ],
            }); 

            let jsonDataApp = generateStandardTemplateInternalId(responses[0].applications);

            dataRows.sheets.push({ id: "Applications", name: "Applications", description: "list of Applications", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataApp, lookup: [] });

            responses[1].technology_components = responses[1].technology_components.sort((a, b) => { 
                return a.name.localeCompare(b.name);
              });

            let jsonDataTC = generateStandardTemplateInternalId(responses[1].technology_components);

            dataRows.sheets.push({ id: "techComponents", name: "Technology Components", description: "list of Technology Components", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataTC, lookup: [] });
 
            responses[2].technology_products = responses[2].technology_products.sort((a, b) => { 
                return a.name.localeCompare(b.name);
              });

            let jsonDataTP = generateStandardTemplateInternalId(responses[2].technology_products);

            dataRows.sheets.push({ id: "techProducts", name: "Technology Products", description: "list of Technology Products", notes: " ", headerRow: 7, headers: headers, visible: false, data: jsonDataTP, lookup: [] });


            const filteredItems = sqvs.filter(item => !/^ *-/.test(item.name));
            let jsonDataSQVs = generateStandardTemplateInternalId(filteredItems);

            dataRows.sheets.push({
                id: "sqvLookup",
                name: "TSQV Lookup",
                description: "list of Tech Serv Quals",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                ],
                visible: false,
                data: jsonDataSQVs,
                lookup: [],
            });

            createPlusWorkbookFromJSON();
        });
    });

    $("#exportTechnologyLifecycles").on("click", function () {
 
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathTechLife),  promise_loadViewerAPIData(viewAPIDataTechProd)]).then(function (responses) {
            let vendorData = [];
            let internalData = [];
            let interalLifes = responses[0].lifecycleJSON.filter((t) => {
                return t.type == "Lifecycle_Status";
            });
            let vendorLifes = responses[0].lifecycleJSON.filter((t) => {
                return t.type == "Vendor_Lifecycle_Status";
            });

            responses[0].technology_lifecycles.forEach((d) => {
                d["beta"] =
                    d.allDates.find((e) => {
                        return e.name == "Beta";
                    }) || "";
                d["ga"] =
                    d.allDates.find((e) => {
                        return e.name == "General Availability";
                    }) || "";
                d["es"] =
                    d.allDates.find((e) => {
                        return e.name == "Extended Support";
                    }) || "";
                d["eol"] =
                    d.allDates.find((e) => {
                        return e.name == "End of Life";
                    }) || "";
                vendorData.push({ vendor: d.supplier, product: d.name, beta: d.beta.dateOf !== undefined ? d.beta.dateOf : "", ga: d.ga.dateOf !== undefined ? d.ga.dateOf : "", es: d.es.dateOf !== undefined ? d.es.dateOf : "", eol: d.eol.dateOf !== undefined ? d.eol.dateOf : "" });
                let internal = d.allDates.filter((e) => {
                    return e.type == "Lifecycle_Status";
                });
                internal.forEach((f) => {
                    internalData.push({ vendor: d.supplier, product: d.name, status: f.name, date: f.dateOf });
                });
            });

            let lf = [];
            let ef = [];
            interalLifes.forEach((l) => {
                lf.push({ id: l.id, name: l.name, desc: l.description !== undefined ? l.description : "", label: l.enumeration_value !== undefined ? l.enumeration_value : "", seq: l.seq, colour: l.backgroundColour });
            });
            vendorLifes.forEach((l) => {
                ef.push({ id: l.id, name: l.name, colour: l.backgroundColour });
            }); 

            responses[1].technology_products = responses[1].technology_products.sort((a, b) => { 
                return a.name.localeCompare(b.name);
              });

            let prods = generateStandardTemplateInternalId(responses[1].technology_products, refMap, plusIdType);
            dataRows.sheets.push({
                id: "techprods",
                name: "Tech Prods",
                description: "A list of technology products",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Descripton", width: 40 },
                ],
                visible: false,
                data: prods,
                lookup: [],
            });

            dataRows.sheets.push({
                id: "techprodinterallifecycle",
                name: "Tech Prod Internal Lifeycle",
                description: "list of Technology Product Internal Lifecycles",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "Supplier", width: 20 },
                    { name: "Product", width: 20 },
                    { name: "Internal Lifecycle Status", width: 20 },
                    { name: "From Date", width: 20 },
                ],
                visible: true,
                data: internalData,
                lookup: [
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Tech Prods" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Internal Tech Prod Lifecycles" }
                ],
            });

            dataRows.sheets.push({
                id: "internalColours",
                name: "Tech Prod Vendor Lifecycle",
                description: "list of External Lifecycles",
                notes: "You MUST use the English terms for mapping here",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "Supplier", width: 20 },
                    { name: "Product", width: 20 },
                    { name: "Beta Start", width: 20 },
                    { name: "GA Start", width: 20 },
                    { name: "Extended Support Start", width: 20 },
                    { name: "EOL Start", width: 20 },
                ],
                visible: true,
                data: vendorData,
                lookup: [
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Tech Prods" }
                ],
            });

            dataRows.sheets.push({
                id: "techprodlifecycle",
                name: "Internal Tech Prod Lifecycles",
                description: "list of internal Lifecycles",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 40 },
                    { name: "Label", width: 20 },
                    { name: "Sequence No", width: 20 },
                    { name: "Colour", width: 20 },
                ],
                visible: true,
                data: lf,
                lookup: [],
            });

            dataRows.sheets.push({
                id: "vendorColours",
                name: "Ref",
                description: "list of Vendor Lifecycles",
                notes: "DO NOT CHANGE THE NAMES OR SEQUENCE HERE",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Colour", width: 20 },
                ],
                visible: true,
                data: ef,
                lookup: [],
            });
            
            createPlusWorkbookFromJSON();
        });
    });

    $("#exportSupplierContractManagement").on("click", function () {
       
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathSupplierImpact), promise_loadViewerAPIData(viewAPIDataBusProcs), promise_loadViewerAPIData(viewAPIDataApps), promise_loadViewerAPIData(viewAPIDataTechProd), promise_loadViewerAPIData(viewAPIDataOrgs)]).then(function (responses) {
           
            //Contract_Type
            let conTypes = responses[0].enums?.filter((e) => {
                return e.type == "Contract_Type";
            });
            let contype = [{ id: "", name: "", description: "", sequence: "", colour: "", styleClass: "", label: "" }];
            if (conTypes) {
                contype = generateContractTypeTemplate(conTypes, refMap, plusIdType);
            }
            dataRows.sheets.push({
                id: "contractTypes",
                name: "Contract Types",
                description: "list of Contract Types",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 40 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 40 },
                    { name: "Score", width: 30 },
                    { name: "Name Translation", width: 40 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 40 },
                    { name: "Custom Label", width: 40 },
                ],
                visible: true,
                data: contype,
                lookup: [],
            });
           
            let owners = generateStandardTemplateInternalId(responses[4].organisations, refMap, plusIdType);
            dataRows.sheets.push({
                id: "contractOwner",
                name: "REF Orgs - Contract Owner",
                description: "list of Contract Owner",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Descripton", width: 40 },
                ],
                visible: false,
                data: owners,
                lookup: [],
            });
            let process = generateStandardTemplateInternalId(responses[1].businessProcesses, refMap, plusIdType);
            dataRows.sheets.push({
                id: "contractbusinessProcesses",
                name: "REF Business Processes",
                description: "list of Business Processes",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Descripton", width: 40 },
                ],
                visible: false,
                data: process,
                lookup: [],
            });
            let apps = generateStandardTemplateInternalId(responses[2].applications, refMap, plusIdType);
            dataRows.sheets.push({
                id: "contractApplications",
                name: "REF Applications",
                description: "list of Applications",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Descripton", width: 40 },
                ],
                visible: false,
                data: apps,
                lookup: [],
            });

            responses[3].technology_products = responses[3].technology_products.sort((a, b) => { 
                return a.name.localeCompare(b.name);
              });

            let tps = generateTPSTemplate(responses[3].technology_products, refMap, plusIdType);
            dataRows.sheets.push({
                id: "contractTechnologyProductsr",
                name: "REF Technology Products",
                description: "list of Technology Products",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Supplier", width: 30 },
                    { name: "Descripton", width: 40 },
                ],
                visible: false,
                data: tps,
                lookup: [],
            });

           

            let renTypes = responses[0].enums.filter((e) => {
                return e.type == "Contract_Renewal_Model";
            });
            let rentype = generateContractType2Template(renTypes, refMap, plusIdType);

            dataRows.sheets.push({
                id: "renewalTypes",
                name: "Renewal Types",
                description: "list of Renewal Types",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 40 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 40 },
                ],
                visible: true,
                data: rentype,
                lookup: [],
            });

            let unitTypes = responses[0].enums.filter((e) => {
                return e.type == "License_Model";
            });
            let unittype = generateContractType2Template(responses[0].enums, refMap, plusIdType);

            dataRows.sheets.push({
                id: "unitTypes",
                name: "Unit Types",
                description: "list of Unit Types",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 40 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 40 },
                ],
                visible: true,
                data: unittype,
                lookup: [],
            });

            let supplierList = generateSupplierTemplate(responses[0].suppliers, refMap, plusIdType);
            dataRows.sheets.push({
                id: "suppliers",
                name: "Suppliers",
                description: "list of Suppliers",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Relationship Status", width: 40 },
                    { name: "Website Link", width: 30 },
                    { name: "External", width: 40 },
                ],
                visible: true,
                data: supplierList,
                lookup: [{ column: "E", values: "C", start: 8, end: 2011, worksheet: "Supplier Relation Status" }],
            });
            
            let contractList = generateContractTemplate(responses[0].contracts, refMap, plusIdType);

            dataRows.sheets.push({
                id: "contracts",
                name: "Contracts",
                description: "list of Contracts",
                notes: " ",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Supplier or Reseller", width: 30 },
                    { name: "Contract Name", width: 30 },
                    { name: "Contract Owner", width: 30 },
                    { name: "Service Description", width: 40 },
                    { name: "Contract Type", width: 40 },
                    { name: "Signature Date (YYYY-MM-DD)", width: 20 },
                    { name: "Renewal Type", width: 20 },
                    { name: "Service End Date (YYYY-MM-DD)", width: 20 },
                    { name: "Service Notice Period (days)", width: 20 },
                    { name: "Document Link - URL", width: 20 },
                ],
                visible: true,
                data: contractList,
                lookup: [
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Suppliers" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "REF Orgs - Contract Owner" },
                    { column: "G", values: "C", start: 8, end: 2011, worksheet: "Contract Types" },
                    { column: "I", values: "C", start: 8, end: 2011, worksheet: "Renewal Types" },
                ],
            });

            // Function to create objects for each element type
            var contcomps = [];
            function createElementObjects(data) {
                data.forEach((parent) => {
                    const newObj = { ...parent };
                    // Helper function to clone parent and add element property

                    newObj["bus"] = "";
                    newObj["app"] = "";
                    newObj["tech"] = "";
                    // Process busElements
                    parent.busElements.forEach((bus) => {
                        newObj.bus = bus.name;
                    });

                    // Process appElements
                    parent.appElements.forEach((app) => {
                        newObj.app = app.name;
                    });

                    // Process techElements
                    parent.techElements.forEach((tech) => {
                        newObj.tech = tech.name;
                    });

                    contcomps.push(newObj);
                });
            }

            // Usage

            createElementObjects(responses[0].contract_components);

            let contractComponentList = generateContractComponentTemplate(contcomps, refMap, plusIdType);
            // Output the result

            dataRows.sheets.push({
                id: "contractcomps",
                name: "Contract Components",
                description: "list of Contracts",
                notes: "Contracted Product / Service (select ONE from THREE columns).	ONLY ADD RENEWAL/SERVICE INFO IF DIFFERENT FROM MAIN CONTRACT.  Comments are not exported but can be added here",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Contract", width: 30 },
                    { name: "Business Process or", width: 30 },
                    { name: "Application or", width: 30 },
                    { name: "Technology Product", width: 40 },
                    { name: "Renewal Type", width: 20 },
                    { name: "Service End Date (YYYY-MM-DD)", width: 20 },
                    { name: "Service Notice Period (days)", width: 10 },
                    { name: "Unit Type", width: 20 },
                    { name: "# of Units", width: 10 },
                    { name: "Total Annual Cost", width: 20 },
                    { name: "Currency", width: 20 },
                    { name: "Comments", width: 40 },
                ],
                visible: true,
                data: contractComponentList,
                lookup: [
                    { column: "C", values: "D", start: 8, end: 2011, worksheet: "Contracts" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "REF Business Processes" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "REF Applications" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "REF Technology Products" },
                    { column: "G", values: "C", start: 8, end: 2011, worksheet: "Renewal Types" },
                    { column: "J", values: "C", start: 8, end: 2011, worksheet: "Unit Types" },
                    { column: "M", values: "C", start: 8, end: 2011, worksheet: "Currency" },
                ],
            });

            let supplierRels = responses[0].enums.filter((e) => {
                return e.type == "Supplier_Relationship_Status";
            });

            let renewals = generatesupplierRels(supplierRels, refMap, plusIdType);
            dataRows.sheets.push({
                id: "supprels",
                name: "Supplier Relation Status",
                description: "list of Supplier Relation Status",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 40 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 40 },
                    { name: "Style Class", width: 20 },
                    { name: "Contract Review Notice", width: 20 },
                ],
                visible: true,
                data: renewals,
                lookup: [],
            });
            let currrencyEnums = responses[0].enums.filter((e) => {
                return e.type == "Currency";
            });
            let currencyList = generateEnums(currrencyEnums);
            dataRows.sheets.push({
                id: "currency",
                name: "Currency",
                description: "list of Currencies",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Description", width: 60 },
                    { name: "Colour", width: 15 },
                    { name: "Style Class", width: 20 },
                    { name: "Index", width: 15 },
                    { name: "Score", width: 15 },
                ],
                visible: true,
                data: currencyList,
                lookup: [],
            });

            createPlusWorkbookFromJSON();
        });
    });

    $("#exportBusinessModels").on("click", function () {
        console.log("exportBusinessModels");
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathAppKPI), promise_loadViewerAPIData(viewAPIPathCapMartKPI), promise_loadViewerAPIData(viewAPIDataOrgs), promise_loadViewerAPIData(viewAPIDataBusProcs), promise_loadViewerAPIData(viewAPIDataBusDoms)]).then(function (responses) {
            
            removeEditorSpinner();
            data = {
                businessModels: responses[1].bus_model_management.businessModels,
                businessModelConfigurations: responses[1].bus_model_management.businessModelConfigurations,
                aris: responses[1].bus_model_management.aris,
                bras: responses[1].bus_model_management.bras,
                arits: responses[1].bus_model_management.arits,
                busRefConf: responses[1].bus_model_management.busRefConf,
                busModelProcess: responses[1].bus_model_management.busModelProcess,
                ref2Process: responses[1].bus_model_management.ref2Process,
                application_provider_roles: responses[1].bus_model_management.application_provider_roles,
            };
           

            data.businessModels.forEach((bm) => {
                
                let foundDomain = responses[4].businessDomains.find((d) => d.id == bm.domain);
                bm["dom"] = foundDomain ? foundDomain.name : "";
            });
           
            let bmList = generateBModel(data.businessModels, refMap, plusIdType);
            //  {"column": "D", "columnNum": "4", "lookUpSheet": "Business Domains", "lookupCol": "C", "val": "domainName"}
            
            dataRows.sheets.push({
                id: "bmods",
                name: "Business Model",
                description: "list of Business Models",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Description", width: 45 },
                    { name: "Business Domain", width: 20 },
                ],
                visible: true,
                data: bmList,
                lookup: [{ column: "E", values: "C", start: 8, end: 2011, worksheet: "Business Domains" }],
            });

            let bmcongfigs = generateBModelConf(data.businessModelConfigurations, refMap, plusIdType);

            dataRows.sheets.push({
                id: "configs", // Using ID from the sheet
                name: "Business Model Configs",
                notes: "",
                headerRow: 7,
                description: "Sheet for Business Model Configurations",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Business Model", width: 30 },
                    { name: "Config Label", width: 30 },
                    { name: "Description", width: 40 },
                    { name: "Org Scope 1", width: 20 },
                    { name: "Org Scope 2", width: 20 },
                    { name: "Org Scope 3", width: 20 },
                    { name: "Org Scope 4", width: 20 },
                    { name: "Org Scope 5", width: 20 },
                    { name: "Org Scope 6", width: 20 },
                    { name: "Full Name", width: 30 },
                ],
                lookup: [
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Model" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "G", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "H", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "I", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "J", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "K", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                ],
                data: bmcongfigs,
                concatenate: [
                    {
                        column: "L",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    },
                ],
            });

            let modelLeaf = [];
            data.busModelProcess.forEach((d) => {
                modelLeaf.push({ model: d.model, leaf: d.leafBC });
            });
            dataRows.sheets.push({
                id: "busModToLeaf",
                name: "Business Model to Leaf Bus Caps",
                notes: "",
                headerRow: 7,
                description: "Mapping of Business Models to Leaf Business Capabilities",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Models", width: 30 },
                    { name: "Leaf Business Capability", width: 30 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Business Model" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Capabilities" },
                ],
                data: modelLeaf,
            });

            let bradata = generateArchitectures(data.bras, refMap, plusIdType);

            dataRows.sheets.push({
                id: "busrefarch", // Assuming ID is unique and provided
                name: "Bus Reference Archs",
                notes: "",
                headerRow: 7,
                description: "Details of Business Reference Architectures",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 40 },
                    { name: "Org Scope 1", width: 30 },
                    { name: "Org Scope 2", width: 30 },
                    { name: "Org Scope 3", width: 30 },
                    { name: "Org Scope 4", width: 30 },
                    { name: "Org Scope 5", width: 30 },
                    { name: "Org Scope 6", width: 30 },
                ],
                lookup: [
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "G", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "H", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "I", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "J", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                ],
                data: bradata,
            });

            let aridata = generateArchitectures(data.aris, refMap, plusIdType);
            dataRows.sheets.push({
                id: "aris", // Assuming ID is unique and provided
                name: "App Reference Impls",
                notes: "",
                headerRow: 7,
                description: "Details of Application Reference Implementations",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 40 },
                    { name: "Org Scope 1", width: 30 },
                    { name: "Org Scope 2", width: 30 },
                    { name: "Org Scope 3", width: 30 },
                    { name: "Org Scope 4", width: 30 },
                    { name: "Org Scope 5", width: 30 },
                    { name: "Org Scope 6", width: 30 },
                ],
                lookup: [
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "G", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "H", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "I", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "J", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Organisations" },
                ],
                data: aridata,
            });

            let arits = [];
            data.arits.forEach((d) => {
                arits.push({ name: d.name, from: d.from, to: d.to });
            });

            dataRows.sheets.push({
                id: "arefimps", // Assuming ID is unique and provided
                name: "App Ref Impls Models",
                notes: "",
                headerRow: 7,
                description: "Details of Application Reference Implementations",
                headers: [
                    { name: "", width: 20 },
                    { name: "Application Reference Implementation", width: 20 },
                    { name: "From Application Provider Role", width: 30 },
                    { name: "To Application Provider Role", width: 40 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "App Reference Impls" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "App Provider Roles" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "App Provider Roles" },
                ],
                data: arits,
            });

            dataRows.sheets.push({
                id: "bptoRef", // Assuming ID is unique and provided
                name: "Bus Ref Arch 2 Process",
                notes: "",
                headerRow: 7,
                description: "Map the Business Reference Architectures to their in scope Business Processes",
                headers: [
                    { name: "", width: 20 },
                    { name: "Reference Architecture", width: 30 },
                    { name: "Business Process", width: 30 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Bus Reference Archs" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Processes" },
                ],
                data: data.ref2Process,
            });

            let brcon = [];
            data.busRefConf.forEach((d) => {
                brcon.push({ bmc: d.name, bra: d.from, ari: d.to });
            });
            dataRows.sheets.push({
                id: 8,
                name: "Bus Model Config 2 Ref Archs",
                notes: "",
                headerRow: 7,
                description: "Mapping of Business Model Configurations to Reference Architectures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Model Config", width: 30 },
                    { name: "From Business Reference Architecture", width: 30 },
                    { name: "From Application Reference Impls", width: 30 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Business Model Configs" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Bus Reference Archs" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "App Reference Impls" },
                ],
                data: brcon,
            });

            function getLeafCapabilitiesIterative(hierarchy) {
                console.log("hierarchy", hierarchy);
                const leafCaps = [];
                const stack = [...hierarchy]; // Clone the hierarchy array

                while (stack.length > 0) {
                    const cap = stack.pop();

                    if (cap.childrenCaps && Array.isArray(cap.childrenCaps) && cap.childrenCaps.length > 0) {
                        // Push all children onto the stack for further processing
                        stack.push(...cap.childrenCaps);
                    } else {
                        // It's a leaf node
                        leafCaps.push(cap);
                    }
                }

                return leafCaps;
            }

            // Example usage:
            const leafCapabilitiesIterative = getLeafCapabilitiesIterative(responses[1].busCapHierarchy, refMap, plusIdType);

            let bcaps = generateIdName(leafCapabilitiesIterative, refMap, plusIdType);

            dataRows.sheets.push({
                id: 11, // Assuming ID is unique and provided
                name: "Business Capabilities",
                notes: "",
                headerRow: 7,
                description: "Details of leaf Business Capabilities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                ],
                lookup: [],
                data: bcaps,
            });

            let aprs = generateIdName(data.application_provider_roles, refMap, plusIdType);
            dataRows.sheets.push({
                id: 13, // Assuming ID is unique and provided
                name: "App Provider Roles",
                notes: "",
                headerRow: 7,
                description: "Details of Application Provider Roles",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                ],
                data: aprs,
            });

            let busProcess = generateIdName(responses[3].businessProcesses, refMap, plusIdType);

            dataRows.sheets.push({
                id: 12, // Assuming ID is unique and provided
                name: "Business Processes",
                notes: "",
                headerRow: 7,
                description: "Details of Business Processes",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                ],
                lookup: [],
                data: busProcess,
            });

            let orgs = generateIdName(responses[2].organisations, refMap, plusIdType);

            dataRows.sheets.push({
                id: "orgs", // Assuming ID is unique and provided
                name: "Organisations",
                notes: "",
                headerRow: 7,
                description: "Details of Organisationss",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                ],
                lookup: [],
                data: orgs,
            });

            let doms = generateIdName(responses[4].businessDomains, refMap, plusIdType);

            dataRows.sheets.push({
                id: "doms", // Assuming ID is unique and provided
                name: "Business Domains",
                notes: "",
                headerRow: 7,
                description: "Details of Business Domains",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                ],
                lookup: [],
                data: doms,
            });

            createPlusWorkbookFromJSON();
        });
    });

    $("#exportValueStreams").on("click", function () {
        console.log("exportValueStreams");
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathStratPlanner)]).then(function (responses) {
        
            let jsonValStreams = generateStandardTemplate(responses[0].valueStreams, refMap, plusIdType);

            dataRows.sheets.push({
                id: "valueStreams",
                name: "Value Streams",
                description: "Value Stream List",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonValStreams,
                lookup: [],
            });

            let jsonProdTypes = generateStandardTemplate(responses[0].productTypes, refMap, plusIdType);
            dataRows.sheets.push({
                id: "ProductTypes",
                name: "Product Types",
                description: "Provides the list of Products associated with Customer Journeys",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonProdTypes,
                lookup: [],
            });

            let jsonRoleTypes = generateStandardTemplate(responses[0].businessRoleTypes, refMap, plusIdType);
            dataRows.sheets.push({
                id: "brts",
                name: "Business Role Types",
                description: "Provides the list of Business Role Types associated with Value Streams or Value Stages",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonRoleTypes,
                lookup: [],
            });

            let jsonOrgRoles = generateStandardTemplate(responses[0].orgBusinessRole, refMap, plusIdType);
            dataRows.sheets.push({
                id: "orgroles",
                name: "Org Business Roles",
                description: "Provides the list of Organisation Business Roles associated with Value Streams or Value Stages",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonOrgRoles,
                lookup: [],
            });

            let jsonIndivRoles = generateStandardTemplate(responses[0].individualBusinessRoles, refMap, plusIdType);
            dataRows.sheets.push({
                id: "valueStreams",
                name: "Individual Business Roles",
                description: "Provides the list of Individual Business Roles associated with Value Streams or Value Stages",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonIndivRoles,
                lookup: [],
            });

            let jsonBusCons = generateStandardTemplate(responses[0].businessConditions, refMap, plusIdType);
            dataRows.sheets.push({
                id: "busCons",
                name: "Business Conditions",
                description: "Provides the list of Business Conditions used in Value Streams or Value Stages",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonBusCons,
                lookup: [],
            });

            let jsonBusEvents = generateStandardTemplate(responses[0].businessEvents, refMap, plusIdType);
            dataRows.sheets.push({
                id: "busevents",
                name: "Business Events",
                description: "Provides the list of Business Events that trigger or occur as a result of Value Streams or Value Stages",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonBusEvents,
                lookup: [],
            });

            let jsonRoles = [];
            responses[0].valueStreams.forEach((d) => {
                d.roles?.forEach((r) => {
                    if (r.type == "Business_Role_Type") {
                        jsonRoles.push({ vs: d.name, brt: r.name, ibr: "", obr: "" });
                    } else if (r.type == "Individual_Business_Role") {
                        jsonRoles.push({ vs: d.name, brt: "", ibr: r.name, obr: "" });
                    } else if (r.type == "Group_Business_Role") {
                        jsonRoles.push({ vs: d.name, brt: "", ibr: "", obr: r.name });
                    }
                });
            });

            dataRows.sheets.push({
                id: "valueStreams",
                name: "Value Stream 2 Stakeholders",
                description: "Maps Value Streams to Business Roles/Role Types that initiate their execution",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Value Stream", width: 20 },
                    { name: "Business Role Type", width: 40 },
                    { name: "Individual Business Role", width: 40 },
                    { name: "Organisation Business Role", width: 40 },
                ],
                visible: true,
                data: jsonRoles,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Value Streams" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Role Types" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Individual Business Roles" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Org Business Roles" },
                ],
            });

            let vsToProdJson = [];
            responses[0].valueStreams.forEach((d) => {
                d.prodTypeIds?.forEach((p) => {
                    let match = responses[0].productTypes.find((pt) => {
                        return pt.id == p;
                    });
                    vsToProdJson.push({ vs: d.name, prod: match.name });
                });
            });

            dataRows.sheets.push({
                id: "valueStreams",
                name: "Value Stream 2 Product Types",
                description: "Maps Value Streams to their associated Product Types",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Value Stream", width: 30 },
                    { name: "Product Type", width: 30 },
                ],
                visible: true,
                data: vsToProdJson,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Value Streams" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Product Types" },
                ],
            });

            let jsonEvents = [];
            responses[0].valueStreams.forEach((d) => {
                d.triggerEvents?.forEach((r) => {
                    jsonEvents.push({ vs: d.name, te: r.name, tc: "", oe: "", oc: "" });
                });
                d.triggerConditions?.forEach((r) => {
                    jsonEvents.push({ vs: d.name, te: "", tc: r.name, oe: "", oc: "" });
                });
                d.outcomeEvents?.forEach((r) => {
                    jsonEvents.push({ vs: d.name, te: "", tc: "", oe: r.name, oc: "" });
                });
                d.outcomeConditions?.forEach((r) => {
                    jsonEvents.push({ vs: d.name, te: "", tc: "", oe: "", oc: r.name });
                });
            });
            dataRows.sheets.push({
                id: "valueStreams",
                name: "Value Stream 2 Events",
                description: "Maps Value Streams to their associated Business Events and Conditions	",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Value Stream", width: 20 },
                    { name: "Trigger Event", width: 40 },
                    { name: "Trigger Condition", width: 60 },
                    { name: "Outcome Event", width: 60 },
                    { name: "Outcome Condition", width: 60 },
                ],
                visible: true,
                data: jsonEvents,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Value Streams" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Events" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Business Conditions" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Business Events" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Business Conditions" },
                ],
            });
       
            let jsonValueStages = generateValStageTemplate(responses[0].valueStages, refMap, plusIdType);
          
            dataRows.sheets.push({
                id: "valueStagesSheet",
                name: "Value Stages",
                description: "Value Stage List",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Parent Value Stream", width: 30 },
                    { name: "Parent Value Stage", width: 30 },
                    { name: "Index", width: 20 },
                    { name: "Stage Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                visible: true,
                data: jsonValueStages,
                lookup: [
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Value Streams" },
                    { column: "D", values: "F", start: 8, end: 2011, worksheet: "Value Stages" },
                ],
                concatenate: {
                    column: "H",
                    type: "=CONCATENATE",
                    formula: 'C, ": ", E, ". ", F',
                },
            });

            let jsonStageRoles = [];
            let stageEmotionJson = []; 
            
            responses[0].valueStages.forEach((d) => {
                d.roles?.forEach((r) => {
                    if (r.type == "Business_Role_Type") {
                        jsonStageRoles.push({ vs: d.name, brt: r.name, ibr: "", obr: "" });
                    } else if (r.type == "Individual_Business_Role") {
                        jsonStageRoles.push({ vs: d.name, brt: "", ibr: r.name, obr: "" });
                    } else if (r.type == "Group_Business_Role") {
                        jsonStageRoles.push({ vs: d.name, brt: "", ibr: "", obr: r.name });
                    }
                });
         
                d.emotions?.forEach((e) => {
                    stageEmotionJson.push({ vs: d.name, emotion: e.emotion, description: e.relation_decription });
                });
            });

            dataRows.sheets.push({
                id: "valueStages",
                name: "Value Stage 2 Participants",
                description: "Maps Value Streams to Business Roles/Role Types that participate in them",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Value Stage", width: 20 },
                    { name: "Business Role Type", width: 40 },
                    { name: "Individual Business Role", width: 40 },
                    { name: "Organisation Business Role", width: 40 },
                ],
                visible: true,
                data: jsonStageRoles,
                lookup: [
                    { column: "B", values: "H", start: 8, end: 2011, worksheet: "Value Stages" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Role Types" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Individual Business Roles" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Org Business Roles" },
                ],
            });
   
            dataRows.sheets.push({
                id: "valueStages",
                name: "Value Stage 2 Emotions",
                description: "Maps Value Stages to their associated Emotions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 },
                    { name: "Value Stage", width: 30 },
                    { name: "Target Emotion", width: 20 },
                    { name: "Target Emotion Description", width: 60 },
                ],
                visible: true,
                data: stageEmotionJson,
                lookup: [
                    { column: "B", values: "H", start: 8, end: 2011, worksheet: "Value Stages" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Customer Emotions" },
                ],
            });

            let jsonValStageConditions = [];
            responses[0].valueStages.forEach((d) => {
                d.entranceEvents?.forEach((r) => {
                    jsonValStageConditions.push({ vs: d.name, ee: r.name, ec: "", xe: "", xc: "" });
                });
                d.entranceCondition?.forEach((r) => {
                    jsonValStageConditions.push({ vs: d.name, ee: "", ec: r.name, xe: "", xc: "" });
                });
                d.exitEvent?.forEach((r) => {
                    jsonValStageConditions.push({ vs: d.name, ee: "", ec: "", xe: r.name, xc: "" });
                });
                d.exitCondition?.forEach((r) => {
                    jsonValStageConditions.push({ vs: d.name, ee: "", ec: "", xe: "", xc: r.name });
                });
            });

            dataRows.sheets.push({
                id: "valueStages",
                name: "Value Stage Criteria",
                description: "Maps Value Stages to their associated entrance/exit Business Events and Conditions",
                notes: "",
                headerRow: 7,
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "Value Stage", width: 30 },
                    { name: "Entrance Event", width: 30 },
                    { name: "Entrance Condition", width: 30 },
                    { name: "Exit Event", width: 30 },
                    { name: "Exit Condition	", width: 30 },
                ],
                visible: true,
                data: jsonValStageConditions,
                lookup: [
                    { column: "B", values: "H", start: 8, end: 2011, worksheet: "Value Stages" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Events" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Business Conditions" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Business Events" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Business Conditions" },
                ],
            });

            let jsonCustEMot = generateCustEmotionEnums(responses[0].customerEmotions, refMap, plusIdType);

            dataRows.sheets.push({
                id: "doms", // Assuming ID is unique and provided
                name: "Customer Emotions",
                notes: "",
                headerRow: 7,
                description: "Details of Customer Emotions and Styles",
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 60 },
                    { name: "Colour", width: 15 },
                    { name: "Style Class", width: 20 },
                    { name: "Index", width: 15 },
                    { name: "Score", width: 15 },
                ],
                lookup: [],
                data: jsonCustEMot,
            });

            let jsonvskpi = [];
            responses[0].valueStages.forEach((d) => {
                d.perfMeasures.forEach((k) => {
                    jsonvskpi.push({ vs: d.name, target: k.quality, value: k.kpiVal, measure: k.uom || "" });
                });
            });

            
            dataRows.sheets.push({
                id: "doms", // Assuming ID is unique and provided
                name: "Value Stages 2 KPI Values",
                notes: "",
                headerRow: 7,
                description: "Details of KPIS for the value stage",
                headers: [
                    { name: "", width: 20 },
                    { name: "Value Stage", width: 30 },
                    { name: "Target KPI", width: 30 },
                    { name: "Target KPI Value", width: 30 },
                    { name: "Unit of Measure (Optional)", width: 30 },
                ],
                lookup: [
                    { column: "B", values: "H", start: 8, end: 2011, worksheet: "Value Stages" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Value Stage KPIs" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Units of Measure" },
                ],
                data: jsonvskpi,
            });

            let vsgkpi=generateStandardTemplate(responses[0].busServiceQuals, refMap, plusIdType);

            dataRows.sheets.push({
                id: "vsgpkis", // Assuming ID is unique and provided
                name: "Value Stage KPIs",
                notes: "",
                headerRow: 7,
                description: "Details of KPIS for the value stage",
                headers: [
                    { name: "", width: 20 }, // If this first column is always empty or has a specific purpose, define it accordingly
                    { name: "ID", width: 20 },
                    { name: "Name", width: 40 },
                    { name: "Description", width: 60 },
                ],
                data: vsgkpi,
            });


            let jsonuom = generateStandardTemplate(responses[0].unitsofMeasure);

            dataRows.sheets.push({
                id: "uoms", // Assuming ID is unique and provided
                name: "Units of Measure",
                notes: "",
                headerRow: 7,
                description: "Details of units of measure",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                ],
                lookup: [],
                data: jsonuom,
            });

            createPlusWorkbookFromJSON();
        });
    });

    $("#exportApplicationKPIs").on("click", function () {
        console.log("exportApplicationKPIs");
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathAppKPI), promise_loadViewerAPIData(viewAPIDataApps)]).then(function (responses) {
       
            let jsonAppData = generateStandardTemplate(responses[1].applications, refMap, plusIdType);
            function groupAppsByServiceQualityVal(apps) {
                const result = {
                    Business_Service_Quality_Value: [],
                    Application_Service_Quality_Value: [],
                    Technology_Service_Quality_Value: [],
                    Information_Service_Quality_Value: [],
                };

                apps.forEach((app) => {
                    const { name, perfMeasures } = app;

                    // Flattening the loops and processing only what's necessary
                    perfMeasures.forEach(({ serviceQuals, date }) => {
                        serviceQuals.forEach(({ type, value, categoryName, serviceName }) => {
                            // Directly pushing the required object to the respective group in the result
                            let bsqval = serviceName + ' - ' + value;
                            result[type].push({
                                name,
                                category: categoryName[0], // Assumes there's always at least one category name
                                bsqval,
                                date,
                            });
                        });
                    });
                });

                return result;
            }

            let grouped = groupAppsByServiceQualityVal(responses[0].applications);

            dataRows.sheets.push({
                id: "apps", // Assuming ID is unique and provided
                name: "Ref Applications",
                notes: "",
                headerRow: 7,
                description: "Details of applications",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 30 },
                ],
                visible: false,
                lookup: [],
                data: jsonAppData,
            });

            dataRows.sheets.push({
                id: "busperf", // Assuming ID is unique and provided
                name: "Business Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Business Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Application", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Business Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Applications" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Business Service Qual Values" },
                ],
                data: grouped["Business_Service_Quality_Value"],
            });
            dataRows.sheets.push({
                id: "infoperf", // Assuming ID is unique and provided
                name: "Info Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Information Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Application", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Information Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Applications" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Information Service Qual Values" },
                ],
                data: grouped["Information_Service_Quality_Value"],
            });

            dataRows.sheets.push({
                id: "appperf", // Assuming ID is unique and provided
                name: "App Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Application Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Application", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Application Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Applications" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Application Service Qual Values" },
                ],
                data: grouped["Application_Service_Quality_Value"],
            });

            dataRows.sheets.push({
                id: "techperf", // Assuming ID is unique and provided
                name: "Technology Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Technology Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Application", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Technology Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Applications" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Technology Service Qual Values" },
                ],
                data: grouped["Technology_Service_Quality_Value"],
            });

            let bqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Business_Service_Quality";
            });
            let iqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Information_Service_Quality";
            });
            let aqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Application_Service_Quality";
            });
            let tqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Technology_Service_Quality";
            });
 
            let bsqJson = generateSQ(bqv);
            let isqJson = generateSQ(iqv);
            let asqJson = generateSQ(aqv);
            let tsqJson = generateSQ(tqv);

            let bsqvJson = generateSQVs(bqv);
            let isqvJson = generateSQVs(iqv);
            let asqvJson = generateSQVs(aqv);
            let tsqvJson = generateSQVs(tqv);

            dataRows.sheets.push({
                id: "busservquals", // Assuming ID is unique and provided
                name: "Business Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Business Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ],
                lookup: [],
                data: bsqJson,
            });

            dataRows.sheets.push({
                id: "busservquals", // Assuming ID is unique and provided
                name: "Business Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Business Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: bsqvJson,
            });
            dataRows.sheets.push({
                id: "infoservquals", // Assuming ID is unique and provided
                name: "Information Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Information Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                ],
                lookup: [],
                data: isqJson,
            });

            dataRows.sheets.push({
                id: "infoservquals", // Assuming ID is unique and provided
                name: "Information Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Information Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 },
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Information Service Quals" }], 
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: isqvJson,
            });

            dataRows.sheets.push({
                id: "appservquals", // Assuming ID is unique and provided
                name: "Application Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Application Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ],
                lookup: [],
                data: asqJson,
            });

            dataRows.sheets.push({
                id: "appservquals", // Assuming ID is unique and provided
                name: "Application Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Application Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Application Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: asqvJson,
            });

            dataRows.sheets.push({
                id: "techservquals", // Assuming ID is unique and provided
                name: "Technology Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Technology Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ], 
                lookup: [],
                data: tsqJson,
            });

            dataRows.sheets.push({
                id: "techservquals", // Assuming ID is unique and provided
                name: "Technology Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Technology Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Technology Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: tsqvJson,
            });

            let pmcs = generatePMCs(responses[0].perfCategory);
    
            dataRows.sheets.push({
                id: "pmcs", // Assuming ID is unique and provided
                name: "Perf Measure Categories",
                notes: "You will need to map the classes manually, check the meat model for the class name, note underscores not spaces must be used",
                headerRow: 7,
                description: "Details of Values for the Performance Measure Categories",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Full Name", width: 30 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Performance Measure Class", width: 30 },
                ],
                lookup: [],
                data: pmcs,
            });

            let perf2class = [];
            responses[0].perfCategory.forEach((d) => {
                d.classes.forEach((e) => {
                    perf2class.push({ perf: d.name, class: e });
                });
            });

            dataRows.sheets.push({
                id: "pmc2class", // Assuming ID is unique and provided
                name: "Perf Measure Cat 2 Class",
                notes: "You will need to map the classes manually, check the meat model for the class name, note underscores not spaces must be used",
                headerRow: 7,
                description: "Details of performance measures to class",
                headers: [
                    { name: "", width: 20 },
                    { name: "Category", width: 20 },
                    { name: "Meta Class", width: 20 },
                ],
                lookup: [{ column: "B", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" }],
                data: perf2class,
            });

            const mapQualitiesToNames = (perfmeasure, servicequalities) => {
                // Create a map for quick lookup of quality names by id
                const qualityMap = servicequalities.reduce((acc, quality) => {
                    acc[quality.id] = { name: quality.name, type: quality.type };
                    return acc;
                }, {});

                // Map each performance measure to add the sqs property
                return perfmeasure.map((item) => {
                    const sqs = item.qualities
                        .map((qualityId) => qualityMap[qualityId]) // Map ids to names
                        .filter(Boolean); // Filter out any undefined values

                    return {
                        ...item,
                        sqs, // Add the new sqs property
                    };
                });
            };

            let ch = mapQualitiesToNames(responses[0].perfCategory, responses[0].serviceQualities);

            let p2s = [];
            ch.forEach((r) => {
                r.sqs.forEach((s) => {
                    p2s.push({ name: r.name, sqs: s.name, type: s.type });
                });
            });
 
            let pbs = p2s.filter((e) => {
                return e.type == "Business_Service_Quality";
            });
            let pis = p2s.filter((e) => {
                return e.type == "Information_Service_Quality";
            });
            let pas = p2s.filter((e) => {
                return e.type == "Application_Service_Quality";
            });
            let pts = p2s.filter((e) => {
                return e.type == "Technology_Service_Quality";
            });
            let p2sSheet = [];
            pbs.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: p.sqs, isq: "", asq: "", tsq: "" });
            });
            pts.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: p.sqs, asq: "", tsq: "" });
            });
            pis.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: "", asq: p.sqs, tsq: "" });
            });
            pas.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: "", asq: "", tsq: p.sqs });
            });
            dataRows.sheets.push({
                id: "pmc2sq", // Assuming ID is unique and provided
                name: "Perf Measure Cat 2 SQ Map",
                notes: "",
                headerRow: 7,
                description: "Details of performance measures mapped service qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "Category", width: 20 },
                    { name: "Business Service Quality", width: 20 },
                    { name: "Technology Service Quality", width: 20 },
                    { name: "Information Service Quality", width: 20 },
                    { name: "Application Service Quality", width: 20 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Service Quals" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Technology Service Quals" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Information Service Quals" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Application Service Quals" },
                ],
                data: p2sSheet,
            });

            createPlusWorkbookFromJSON();
        });
    });
 
    $("#exportCapabilityKPIs").on("click", function () {
         
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathBusKPI), promise_loadViewerAPIData(viewAPIDataBusCaps)]).then(function (responses) {
       
            let jsonCapData = generateStandardTemplate(responses[1].businessCapabilities);
            function groupCapsByServiceQualityVal(caps) {
                const result = {
                    Business_Service_Quality_Value: [],
                    Application_Service_Quality_Value: [],
                    Technology_Service_Quality_Value: [],
                    Information_Service_Quality_Value: [],
                };

                caps.forEach((app) => {
                    const { name, perfMeasures } = app;

                    // Flattening the loops and processing only what's necessary
                    perfMeasures.forEach(({ serviceQuals, date }) => {
                        serviceQuals.forEach(({ type, value, categoryName, serviceName }) => {
                            // Directly pushing the required object to the respective group in the result
                            let bsqval = serviceName + ' - ' + value;
                            result[type].push({
                                name,
                                category: categoryName[0], // Assumes there's always at least one category name
                                bsqval,
                                date,
                            });
                        });
                    });
                });

                return result;
            }

            let grouped = groupCapsByServiceQualityVal(responses[0].businessCapabilities);
            
            dataRows.sheets.push({
                id: "apps", // Assuming ID is unique and provided
                name: "Ref Capabilities",
                notes: "",
                headerRow: 7,
                description: "Details of capabilities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 30 },
                ],
                visible: false,
                lookup: [],
                data: jsonCapData,
            });

            dataRows.sheets.push({
                id: "busperf", // Assuming ID is unique and provided
                name: "Business Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Business Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Capability", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Business Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                visible: true,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Capabilities" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Business Service Qual Values" },
                ],
                data: grouped["Business_Service_Quality_Value"],
            });
            dataRows.sheets.push({
                id: "infoperf", // Assuming ID is unique and provided
                name: "Info Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Information Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Capability", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Information Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                visible: true,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Capabilities" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Information Service Qual Values" },
                ],
                data: grouped["Information_Service_Quality_Value"],
            });

            dataRows.sheets.push({
                id: "appperf", // Assuming ID is unique and provided
                name: "App Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Application Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Capability", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Application Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                visible: true,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Capabilities" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Application Service Qual Values" },
                ],
                data: grouped["Application_Service_Quality_Value"],
            });

            dataRows.sheets.push({
                id: "techperf", // Assuming ID is unique and provided
                name: "Technology Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Technology Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Capability", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Technology Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                visible: true,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Capabilities" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Technology Service Qual Values" },
                ],
                data: grouped["Technology_Service_Quality_Value"],
            });

            let bqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Business_Service_Quality";
            });
            let iqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Information_Service_Quality";
            });
            let aqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Application_Service_Quality";
            });
            let tqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Technology_Service_Quality";
            });
 
            let bsqJson = generateSQ(bqv);
            let isqJson = generateSQ(iqv);
            let asqJson = generateSQ(aqv);
            let tsqJson = generateSQ(tqv);

            //   Filter objects with 'Business_Process' in classes
            const filteredPCs = responses[0].perfCategory.filter(obj => obj.classes.includes("Business_Capability"));

            //   Extract and flatten qualities arrays
            const qualitiesArray = filteredPCs.flatMap(obj => obj.qualities);
 
            // Step 3: Filter bqv by matching ids
            const filteredBqv = bqv.filter(e => qualitiesArray.includes(e.id) && e.type === "Business_Service_Quality");
            const filteredIqv = iqv.filter(e => qualitiesArray.includes(e.id) && e.type === "Information_Service_Quality");
            const filteredAqv = aqv.filter(e => qualitiesArray.includes(e.id) && e.type === "Application_Service_Quality");
            const filteredTqv = tqv.filter(e => qualitiesArray.includes(e.id) && e.type === "Technology_Service_Quality");
              
            let bsqvJson = generateSQVs(filteredBqv);
            let isqvJson = generateSQVs(filteredIqv);
            let asqvJson = generateSQVs(filteredAqv);
            let tsqvJson = generateSQVs(filteredTqv);
        
            dataRows.sheets.push({
                id: "busservquals", // Assuming ID is unique and provided
                name: "Business Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Business Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ],
                lookup: [],
                visible: false,
                data: bsqJson,
            });

            dataRows.sheets.push({
                id: "busservquals", // Assuming ID is unique and provided
                name: "Business Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Business Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                visible: false,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: bsqvJson,
            });
            dataRows.sheets.push({
                id: "infoservquals", // Assuming ID is unique and provided
                name: "Information Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Information Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                ],
                visible: false,
                lookup: [],
                data: isqJson,
            });

            dataRows.sheets.push({
                id: "infoservquals", // Assuming ID is unique and provided
                name: "Information Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Information Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 },
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                visible: false,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Information Service Quals" }], 
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: isqvJson,
            });

            dataRows.sheets.push({
                id: "appservquals", // Assuming ID is unique and provided
                name: "Application Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Application Service Qualities",
                visible: false,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ],
                lookup: [],
                data: asqJson,
            });

            dataRows.sheets.push({
                id: "appservquals", // Assuming ID is unique and provided
                name: "Application Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Application Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                visible: false,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Application Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: asqvJson,
            });

            dataRows.sheets.push({
                id: "techservquals", // Assuming ID is unique and provided
                name: "Technology Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Technology Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ], 
                visible: false,
                lookup: [],
                data: tsqJson,
            });

            dataRows.sheets.push({
                id: "techservquals", // Assuming ID is unique and provided
                name: "Technology Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Technology Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                visible: false,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Technology Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: tsqvJson,
            });
 
            let pmcs = generatePMCs(filteredPCs);

            dataRows.sheets.push({
                id: "pmcs", // Assuming ID is unique and provided
                name: "Perf Measure Categories",
                notes: "You will need to map the classes manually, check the meat model for the class name, note underscores not spaces must be used",
                headerRow: 7,
                description: "Details of Values for the Performance Measure Categories",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Full Name", width: 30 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Performance Measure Class", width: 30 },
                ],
                lookup: [],
                visible: false,
                data: pmcs,
            });

            let perf2class = [];
            responses[0].perfCategory.forEach((d) => {
                d.classes.forEach((e) => {
                    perf2class.push({ perf: d.name, class: e });
                });
            });

            dataRows.sheets.push({
                id: "pmc2class", // Assuming ID is unique and provided
                name: "Perf Measure Cat 2 Class",
                notes: "You will need to map the classes manually, check the meat model for the class name, note underscores not spaces must be used",
                headerRow: 7,
                description: "Details of performance measures to class",
                headers: [
                    { name: "", width: 20 },
                    { name: "Category", width: 20 },
                    { name: "Meta Class", width: 20 },
                ],
                visible: false,
                lookup: [{ column: "B", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" }],
                data: perf2class,
            });

            const mapQualitiesToNames = (perfmeasure, servicequalities) => {
                // Create a map for quick lookup of quality names by id
                const qualityMap = servicequalities.reduce((acc, quality) => {
                    acc[quality.id] = { name: quality.name, type: quality.type };
                    return acc;
                }, {});

                // Map each performance measure to add the sqs property
                return perfmeasure.map((item) => {
                    const sqs = item.qualities
                        .map((qualityId) => qualityMap[qualityId]) // Map ids to names
                        .filter(Boolean); // Filter out any undefined values

                    return {
                        ...item,
                        sqs, // Add the new sqs property
                    };
                });
            };

            let ch = mapQualitiesToNames(responses[0].perfCategory, responses[0].serviceQualities);

            let p2s = [];
            ch.forEach((r) => {
                r.sqs.forEach((s) => {
                    p2s.push({ name: r.name, sqs: s.name, type: s.type });
                });
            });
 
            let pbs = p2s.filter((e) => {
                return e.type == "Business_Service_Quality";
            });
            let pis = p2s.filter((e) => {
                return e.type == "Information_Service_Quality";
            });
            let pas = p2s.filter((e) => {
                return e.type == "Application_Service_Quality";
            });
            let pts = p2s.filter((e) => {
                return e.type == "Technology_Service_Quality";
            });
            let p2sSheet = [];
            pbs.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: p.sqs, isq: "", asq: "", tsq: "" });
            });
            pts.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: p.sqs, asq: "", tsq: "" });
            });
            pis.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: "", asq: p.sqs, tsq: "" });
            });
            pas.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: "", asq: "", tsq: p.sqs });
            });
            dataRows.sheets.push({
                id: "pmc2sq", // Assuming ID is unique and provided
                name: "Perf Measure Cat 2 SQ Map",
                notes: "",
                headerRow: 7,
                description: "Details of performance measures mapped service qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "Category", width: 20 },
                    { name: "Business Service Quality", width: 20 },
                    { name: "Technology Service Quality", width: 20 },
                    { name: "Information Service Quality", width: 20 },
                    { name: "Application Service Quality", width: 20 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Service Quals" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Technology Service Quals" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Information Service Quals" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Application Service Quals" },
                ],
                visible: false,
                data: p2sSheet,
            });

            createPlusWorkbookFromJSON();
        });
    });

    $("#exportProcessKPIs").on("click", function () {
    
        dataRows = { sheets: [] };
        Promise.all([promise_loadViewerAPIData(viewAPIPathBusKPI), promise_loadViewerAPIData(viewAPIDataBusProcs)]).then(function (responses) {
       
            let jsonCapData = generateStandardTemplate(responses[1].businessProcesses);
            function groupProcsByServiceQualityVal(proc) {
                const result = {
                    Business_Service_Quality_Value: [],
                    Application_Service_Quality_Value: [],
                    Technology_Service_Quality_Value: [],
                    Information_Service_Quality_Value: [],
                };

                proc.forEach((app) => {
                    const { name, perfMeasures } = app;

                    // Flattening the loops and processing only what's necessary
                    perfMeasures.forEach(({ serviceQuals, date }) => {
                        serviceQuals.forEach(({ type, value, categoryName, serviceName }) => {
                            // Directly pushing the required object to the respective group in the result
                            let bsqval = serviceName + ' - ' + value;
                            result[type].push({
                                name,
                                category: categoryName[0], // Assumes there's always at least one category name
                                bsqval,
                                date,
                            });
                        });
                    });
                });

                return result;
            }

            let grouped = groupProcsByServiceQualityVal(responses[0].processes);
         
            dataRows.sheets.push({
                id: "procs", // Assuming ID is unique and provided
                name: "Ref Processes",
                notes: "",
                headerRow: 7,
                description: "Details of processes",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 30 },
                    { name: "Description", width: 30 },
                ],
                visible: false,
                lookup: [],
                data: jsonCapData,
            });

            dataRows.sheets.push({
                id: "busperf", // Assuming ID is unique and provided
                name: "Business Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Business Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Process", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Business Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                visible: true,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Processes" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Business Service Qual Values" },
                ],
                data: grouped["Business_Service_Quality_Value"],
            });
            dataRows.sheets.push({
                id: "infoperf", // Assuming ID is unique and provided
                name: "Info Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Information Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Process", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Information Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                visible: true,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Processes" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Information Service Qual Values" },
                ],
                data: grouped["Information_Service_Quality_Value"],
            });

            dataRows.sheets.push({
                id: "appperf", // Assuming ID is unique and provided
                name: "App Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Application Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Process", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Application Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                visible: true,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Processes" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Application Service Qual Values" },
                ],
                data: grouped["Application_Service_Quality_Value"],
            });

            dataRows.sheets.push({
                id: "techperf", // Assuming ID is unique and provided
                name: "Technology Performance Measures",
                notes: "",
                headerRow: 7,
                description: "Details of Technology Performance Measures",
                headers: [
                    { name: "", width: 20 },
                    { name: "Business Process", width: 20 },
                    { name: "Measure Category", width: 20 },
                    { name: "Technology Service Quality Value", width: 20 },
                    { name: "Measure Date (YYYY-MM-DD)", width: 30 },
                ],
                visible: true,
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Ref Processes" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "D", values: "M", start: 8, end: 2011, worksheet: "Technology Service Qual Values" },
                ],
                data: grouped["Technology_Service_Quality_Value"],
            });

            let bqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Business_Service_Quality";
            });
            let iqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Information_Service_Quality";
            });
            let aqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Application_Service_Quality";
            });
            let tqv = responses[0].serviceQualities.filter((e) => {
                return e.type == "Technology_Service_Quality";
            });
            const filteredPCs = responses[0].perfCategory.filter(obj => obj.classes.includes("Business_Process"));
      
            //   Extract and flatten qualities arrays
            const qualitiesArray = filteredPCs.flatMap(obj => obj.qualities);

            // Step 3: Filter bqv by matching ids
            const filteredBqv = bqv.filter(e => qualitiesArray.includes(e.id) && e.type === "Business_Service_Quality");
            const filteredIqv = iqv.filter(e => qualitiesArray.includes(e.id) && e.type === "Information_Service_Quality");
            const filteredAqv = aqv.filter(e => qualitiesArray.includes(e.id) && e.type === "Application_Service_Quality");
            const filteredTqv = tqv.filter(e => qualitiesArray.includes(e.id) && e.type === "Technology_Service_Quality");
 
 
            let bsqJson = generateSQ(bqv);
            let isqJson = generateSQ(iqv);
            let asqJson = generateSQ(aqv);
            let tsqJson = generateSQ(tqv);

            let bsqvJson = generateSQVs(filteredBqv);
            let isqvJson = generateSQVs(filteredIqv);
            let asqvJson = generateSQVs(filteredAqv);
            let tsqvJson = generateSQVs(filteredTqv);

            dataRows.sheets.push({
                id: "busservquals", // Assuming ID is unique and provided
                name: "Business Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Business Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ],
                lookup: [],
                visible: false,
                data: bsqJson,
            });

            dataRows.sheets.push({
                id: "busservquals", // Assuming ID is unique and provided
                name: "Business Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Business Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                visible: false,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: bsqvJson,
            });
            dataRows.sheets.push({
                id: "infoservquals", // Assuming ID is unique and provided
                name: "Information Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Information Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                ],
                visible: false,
                lookup: [],
                data: isqJson,
            });

            dataRows.sheets.push({
                id: "infoservquals", // Assuming ID is unique and provided
                name: "Information Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Information Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 },
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                visible: false,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Information Service Quals" }], 
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: isqvJson,
            });

            dataRows.sheets.push({
                id: "appservquals", // Assuming ID is unique and provided
                name: "Application Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Application Service Qualities",
                visible: false,
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ],
                lookup: [],
                data: asqJson,
            });

            dataRows.sheets.push({
                id: "appservquals", // Assuming ID is unique and provided
                name: "Application Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Application Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                visible: false,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Application Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: asqvJson,
            });

            dataRows.sheets.push({
                id: "techservquals", // Assuming ID is unique and provided
                name: "Technology Service Quals",
                notes: "",
                headerRow: 7,
                description: "Details of Technology Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Name", width: 20 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Weighting", width: 30 },
                ], 
                visible: false,
                lookup: [],
                data: tsqJson,
            });

            dataRows.sheets.push({
                id: "techservquals", // Assuming ID is unique and provided
                name: "Technology Service Qual Values",
                notes: "",
                headerRow: 7,
                description: "Details of Values for the Technology Service Qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Service Quality", width: 20 },
                    { name: "Value", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Colour", width: 30 },
                    { name: "Style Class", width: 30 }, 
                    { name: "Score", width: 30 }, 
                    { name: "Name Translation", width: 30 },
                    { name: "Description Translation", width: 30 },
                    { name: "Language", width: 30 }, 
                    { name: "Concat", width: 30 },
                ],
                visible: false,
                lookup: [{ column: "C", values: "C", start: 8, end: 2011, worksheet: "Technology Service Quals" }],
                concatenate: [
                    {
                        column: "M",
                        type: "=CONCATENATE",
                        formula: 'C, " - ", D',
                    }],
                data: tsqvJson,
            });

             let pmcs = generatePMCs(filteredPCs);
    
            dataRows.sheets.push({
                id: "pmcs", // Assuming ID is unique and provided
                name: "Perf Measure Categories",
                notes: "You will need to map the classes manually, check the meat model for the class name, note underscores not spaces must be used",
                headerRow: 7,
                description: "Details of Values for the Performance Measure Categories",
                headers: [
                    { name: "", width: 20 },
                    { name: "ID", width: 20 },
                    { name: "Full Name", width: 30 },
                    { name: "Label", width: 20 },
                    { name: "Description", width: 30 },
                    { name: "Sequence No", width: 30 },
                    { name: "Performance Measure Class", width: 30 },
                ],
                lookup: [],
                visible: false,
                data: pmcs,
            });

            let perf2class = [];
            responses[0].perfCategory.forEach((d) => {
                d.classes.forEach((e) => {
                    perf2class.push({ perf: d.name, class: e });
                });
            });

            dataRows.sheets.push({
                id: "pmc2class", // Assuming ID is unique and provided
                name: "Perf Measure Cat 2 Class",
                notes: "You will need to map the classes manually, check the meat model for the class name, note underscores not spaces must be used",
                headerRow: 7,
                description: "Details of performance measures to class",
                headers: [
                    { name: "", width: 20 },
                    { name: "Category", width: 20 },
                    { name: "Meta Class", width: 20 },
                ],
                visible: false,
                lookup: [{ column: "B", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" }],
                data: perf2class,
            });

            const mapQualitiesToNames = (perfmeasure, servicequalities) => {
                // Create a map for quick lookup of quality names by id
                const qualityMap = servicequalities.reduce((acc, quality) => {
                    acc[quality.id] = { name: quality.name, type: quality.type };
                    return acc;
                }, {});

                // Map each performance measure to add the sqs property
                return perfmeasure.map((item) => {
                    const sqs = item.qualities
                        .map((qualityId) => qualityMap[qualityId]) // Map ids to names
                        .filter(Boolean); // Filter out any undefined values

                    return {
                        ...item,
                        sqs, // Add the new sqs property
                    };
                });
            };

            let ch = mapQualitiesToNames(responses[0].perfCategory, responses[0].serviceQualities);

            let p2s = [];
            ch.forEach((r) => {
                r.sqs.forEach((s) => {
                    p2s.push({ name: r.name, sqs: s.name, type: s.type });
                });
            });
 
            let pbs = p2s.filter((e) => {
                return e.type == "Business_Service_Quality";
            });
            let pis = p2s.filter((e) => {
                return e.type == "Information_Service_Quality";
            });
            let pas = p2s.filter((e) => {
                return e.type == "Application_Service_Quality";
            });
            let pts = p2s.filter((e) => {
                return e.type == "Technology_Service_Quality";
            });
            let p2sSheet = [];
            pbs.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: p.sqs, isq: "", asq: "", tsq: "" });
            });
            pts.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: p.sqs, asq: "", tsq: "" });
            });
            pis.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: "", asq: p.sqs, tsq: "" });
            });
            pas.forEach((p) => {
                p2sSheet.push({ cat: p.name, bsq: "", isq: "", asq: "", tsq: p.sqs });
            });
            dataRows.sheets.push({
                id: "pmc2sq", // Assuming ID is unique and provided
                name: "Perf Measure Cat 2 SQ Map",
                notes: "",
                headerRow: 7,
                description: "Details of performance measures mapped service qualities",
                headers: [
                    { name: "", width: 20 },
                    { name: "Category", width: 20 },
                    { name: "Business Service Quality", width: 20 },
                    { name: "Technology Service Quality", width: 20 },
                    { name: "Information Service Quality", width: 20 },
                    { name: "Application Service Quality", width: 20 },
                ],
                lookup: [
                    { column: "B", values: "C", start: 8, end: 2011, worksheet: "Perf Measure Categories" },
                    { column: "C", values: "C", start: 8, end: 2011, worksheet: "Business Service Quals" },
                    { column: "D", values: "C", start: 8, end: 2011, worksheet: "Technology Service Quals" },
                    { column: "E", values: "C", start: 8, end: 2011, worksheet: "Information Service Quals" },
                    { column: "F", values: "C", start: 8, end: 2011, worksheet: "Application Service Quals" },
                ],
                visible: false,
                data: p2sSheet,
            });

            createPlusWorkbookFromJSON();
        });
    });
   
});
