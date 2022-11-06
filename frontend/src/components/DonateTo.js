import React from "react";

export function DonateTo({ txTo }) {
  return (
    <div className="alert alert-info" role="alert">
       <strong>{txTo}</strong> 
    </div>
  );
}
